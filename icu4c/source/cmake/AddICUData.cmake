include_guard()

include(AddICUTarget)

add_custom_rule(rb
  OUTPUT "<CURRENT_BINARY_DIR>/<BASE_NAME>.res"
  COMMAND genrb
          -d "<CURRENT_BINARY_DIR>"
          <SOURCE>
)

function(add_icu_data name)
    set(options "")
    set(one_value_args "")
    set(multi_value_args SOURCES)
    cmake_parse_arguments(
        PARSE_ARGN
        arg
        "${options}"
        "${one_value_args}"
        "${multi_value_args}"
    )

    set(res_tgt ${name}_res)
    set(in_file_set res_srcs)
    add_library(${name}_res INTERFACE)
    target_sources(
        ${name}_res
        INTERFACE FILE_SET ${in_file_set} TYPE rb FILES ${arg_SOURCES}
    )

    set(out_file_set __cmake_rule_rb_${res_tgt}_${in_file_set}_outputs)
    set(genex_outputs $<TARGET_PROPERTY:${res_tgt},SOURCE_SET_${out_file_set}>)
    file(
        GENERATE OUTPUT ${name}.lst
        CONTENT
            $<JOIN:$<PATH:RELATIVE_PATH,${genex_outputs},${CMAKE_CURRENT_BINARY_DIR}>,\n>\n
    )

    add_custom_command(
        OUTPUT ${name}.dat
        COMMAND icupkg -a ${name}.lst new ${name}.dat
        DEPENDS ${genex_outputs}
    )
    add_custom_command(
        OUTPUT ${name}.c
        COMMAND
            ${CMAKE_COMMAND} -DICU_DATA_NAME=${name} -P
            ${ICU_SOURCE_DIR}/cmake/GenData.cmake
        DEPENDS ${name}.dat
    )
    add_library(${name} OBJECT ${CMAKE_CURRENT_BINARY_DIR}/${name}.c)
    if(ICU_HAVE_C23)
        set_target_properties(${name} PROPERTIES C_STANDARD 23)
    endif()
    target_link_libraries(${name} PRIVATE uc)
endfunction()

function(add_icu_dat name)
    set(options "")
    set(one_value_args
        LIST_FILE
        SOURCE_DIR
        TARGET
        DEST_DIR
        ICUPKG_TOOL
        ENTRY
        MODE
    )
    set(multi_value_args DEPENDS)
    cmake_parse_arguments(
        PARSE_ARGN
        arg
        "${options}"
        "${one_value_args}"
        "${multi_value_args}"
    )

    set(ICUPKG_TOOL icupkg)
    if(arg_ICUPKG_TOOL)
        set(ICUPKG_TOOL ${arg_ICUPKG_TOOL})
    endif()

    add_custom_command(
        OUTPUT ${arg_DEST_DIR}/${name}.dat
        COMMAND
            ${ICUPKG_TOOL} -a ${arg_LIST_FILE} -s ${arg_SOURCE_DIR} new
            ${arg_DEST_DIR}/${name}.dat
        DEPENDS ${arg_DEPENDS} ${arg_LIST_FILE}
    )

    if(arg_MODE STREQUAL "archive")
        return()
    endif()

    if(NOT arg_ENTRY)
        message(FATAL_ERROR "must define entry point")
    endif()

    if(ICU_HAVE_C23)
        set(data_suffix .dat)
    else()
        set(data_suffix .inc)
        add_custom_command(
            OUTPUT ${arg_DEST_DIR}/${name}.inc
            COMMAND
                ${CMAKE_COMMAND} -E bin2c -- ${arg_DEST_DIR}/${name}.dat
                ${arg_DEST_DIR}/${name}.inc
            DEPENDS ${arg_DEST_DIR}/${name}.dat
        )
    endif()

    add_custom_command(
        OUTPUT ${name}.c
        COMMAND
            ${CMAKE_COMMAND} -DICU_DATA_ENTRY=${arg_ENTRY}
            -DICU_DATA_PATH=${arg_DEST_DIR}/${name}${data_suffix}
            -DICU_DATA_NAME=${name} -P ${ICU_SOURCE_DIR}/cmake/GenData.cmake
        DEPENDS ${arg_DEST_DIR}/${name}${data_suffix}
    )
    add_icu_library(${arg_TARGET})
    target_sources(${arg_TARGET} PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/${name}.c)
    target_include_directories(${arg_TARGET} PRIVATE ${ICU_SOURCE_DIR}/common)
    if(ICU_HAVE_C23)
        set_target_properties(${arg_TARGET} PROPERTIES C_STANDARD 23)
    endif()
endfunction()
