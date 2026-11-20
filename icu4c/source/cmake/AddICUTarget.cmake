include_guard()

include(GNUInstallDirs)

function(add_icu_prefix_suffix tgt)
    get_target_property(output_name "${tgt}" OUTPUT_NAME)

    if(NOT output_name)
        set(output_name ${tgt})
    endif()

    set_target_properties(
        ${tgt}
        PROPERTIES OUTPUT_NAME "icu${output_name}${ICU_WITH_LIBRARY_SUFFIX}"
    )
endfunction()

function(add_icu_compile_options tgt)
    set(common_options "")
    set(c_options "")
    set(cxx_options "")
    if(CMAKE_C_COMPILER_FRONTEND_VARIANT STREQUAL "GNU")
        if(NOT ICU_DISABLE_STRICT)
            list(
                APPEND common_options
                -Wall
                -pedantic
                -Wshadow
                -Wpointer-arith
                -Wmissing-prototypes
                -Wwrite-strings
            )
        endif()
    endif()

    if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "GNU")
        list(APPEND cxx_options -fno-exceptions)
    endif()

    if (MSVC)
        target_compile_definitions(${tgt}
            PRIVATE
            _CRT_SECURE_NO_WARNING
        )
    endif()

    if(CMAKE_C_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
        list(APPEND common_options -Zc:inline -utf-8)
        if(NOT ICU_DISABLE_STRICT)
            list(APPEND common_options -W4)
        endif()
    endif()
    if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
        target_compile_definitions(${tgt} PRIVATE _HAS_EXCEPTIONS=0)
    endif()

    target_compile_options(
        ${tgt}
        PRIVATE
            ${common_options}
            "$<$<COMPILE_LANGUAGE:C>:${c_options}>"
            "$<$<COMPILE_LANGUAGE:CXX>:${cxx_options}>"
    )
endfunction()

function(add_icu_target tgt)
    set(options NO_SOURCES)
    set(one_value_args KIND)
    set(multi_value_args "")
    cmake_parse_arguments(
        PARSE_ARGN
        arg
        "${options}"
        "${one_value_args}"
        "${multi_value_args}"
    )

    if(arg_KIND STREQUAL "LIB")
        add_library(${tgt})
        cmake_language(
            EVAL CODE
                "cmake_language(DEFER CALL add_icu_prefix_suffix [[${tgt}]])"
        )
    elseif(arg_KIND STREQUAL "EXE")
        add_executable(${tgt})
    endif()

    if(NOT arg_NO_SOURCES AND EXISTS ${CMAKE_CURRENT_LIST_DIR}/sources.txt)
        file(STRINGS sources.txt sources)
        target_sources(${tgt} PRIVATE ${sources})
    endif()
    add_icu_compile_options(${tgt})
endfunction()

function(add_icu_library tgt)
    add_icu_target(${tgt} KIND LIB ${ARGN})
endfunction()

function(add_icu_executable tgt)
    add_icu_target(${tgt} KIND EXE ${ARGN})
endfunction()

function(add_icu_test tgt)
    add_icu_executable(${tgt})
    target_compile_definitions(
        ${tgt}
        PRIVATE
            "U_TOPBUILDDIR=\"${ICU_TEST_TOPBUILDDIR}\""
            "U_TOPSRCDIR=\"${ICU_TOPSRCDIR}\""
    )

    add_test(NAME ${tgt} COMMAND ${tgt})
endfunction()

function(install_icu_target tgt)
    install(
        TARGETS ${tgt}
        ARCHIVE COMPONENT Development
        RUNTIME COMPONENT Runtime
        LIBRARY COMPONENT Runtime NAMELINK_COMPONENT Development
        FILE_SET HEADERS COMPONENT Development
    )
endfunction()
