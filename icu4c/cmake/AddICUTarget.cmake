include_guard()

include(GNUInstallDirs)

function(add_prefix_suffix tgt)
  get_target_property(output_name "${tgt}" OUTPUT_NAME)

  if(NOT output_name)
    set(output_name ${tgt})
  endif()

  set_target_properties(${tgt}
    PROPERTIES
    OUTPUT_NAME
    "icu${output_name}${ICU_WITH_LIBRARY_SUFFIX}${PROJECT_VERSION_MAJOR}"
    ARCHIVE_OUTPUT_NAME
    "icu${output_name}${ICU_WITH_LIBRARY_SUFFIX}"
    RUNTIME_OUTPUT_NAME
    "icu${output_name}${ICU_WITH_LIBRARY_SUFFIX}${PROJECT_VERSION_MAJOR}"
  )
endfunction()

function(modify_test_env name)
  set(rt_dll_dirs $<TARGET_RUNTIME_DLL_DIRS:${name}>)
  set(env_mod "$<LIST:JOIN,${rt_dll_dirs},;PATH=path_list_append:>")

  set_tests_properties(${name}
    PROPERTIES
    ENVIRONMENT_MODIFICATION
    "PATH=path_list_append:${env_mod}"
  )
endfunction()

function(add_icu_target type name)
  set(options NO_INSTALL)
  set(one_val_args EXPORT)
  set(mult_val_args SOURCES)
  cmake_parse_arguments(arg
    "${options}" "${one_val_args}" "${mult_val_args}"
    ${ARGN}
  )

  if(type STREQUAL "LIB")
    add_library(${name} ${arg_UNPARSED_ARGUMENTS})
  elseif(type STREQUAL "TEST")
    add_executable(${name})
    add_test(NAME ${name}
      COMMAND ${name}
      WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    )
  else()
    add_executable(${name})
  endif()

  set_target_properties(${name} PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
  )

  if(arg_SOURCES)
    target_sources(${name}
      ${arg_SOURCES}
    )
  endif()

  target_compile_definitions(${name}
    PRIVATE
    U_ALL_IMPLEMENTATION
    U_ATTRIBUTE_DEPRECATED=
  )

  # MSVC
  block()

  if(MSVC)
    target_compile_definitions(${name}
      PRIVATE
      _CRT_SECURE_NO_WARNINGS
    )
  endif()

  set(common_options
    -utf-8
    -Zc:preprocessor
    -Zc:inline
  )

  if(NOT ICU_DISABLE_STRICT)
    list(APPEND common_options "-W4")
  endif()

  if(CMAKE_C_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
    target_compile_options(${name}
      PRIVATE
      "$<$<COMPILE_LANGUAGE:C>:${common_options}>"
    )
  endif()

  set(cxx_options
    -Zc:__cplusplus
    -permissive-
  )

  if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
    target_compile_options(${name}
      PRIVATE
      "$<$<COMPILE_LANGUAGE:CXX>:${common_options};${cxx_options}>"
    )
    target_compile_definitions(${name}
      PRIVATE
      _HAS_EXCEPTIONS=0
    )
  endif()

  endblock()

  # gnu
  block()
  set(c_options "")
  set(cxx_options "-fno-exceptions")

  if(CMAKE_C_COMPILER_FRONTEND_VARIANT STREQUAL "GNU")
    if(NOT ICU_DISABLE_STRICT)
      list(APPEND c_options -Wall -pedantic
        -Wshadow -Wpointer-arith
        -Wmissing-prototypes -Wwrite-strings
      )
      list(APPEND cxx_options -W -Wall -pedantic
        -Wpointer-arith -Wwrite-strings -Wno-long-long
      )
    endif()

    target_compile_options(${name}
      PRIVATE
      "$<$<COMPILE_LANGUAGE:C>:${c_options}>"
    )
  endif()

  if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "GNU")
    target_compile_options(${name}
      PRIVATE
      "$<$<COMPILE_LANGUAGE:CXX>:${cxx_options}>"
    )
  endif()

  endblock()

  if(NOT arg_NO_INSTALL)
    set(export_option "")

    if(arg_EXPORT)
      set(export_option EXPORT ${arg_EXPORT})
    endif()

    install(TARGETS ${name}
      ${export_option}
      ARCHIVE
      COMPONENT Development
      LIBRARY
      COMPONENT Runtime
      NAMELINK_COMPONENT Development
      RUNTIME
      COMPONENT Runtime
      FILE_SET HEADERS
      COMPONENT Development
    )
  endif()

  if(type STREQUAL "LIB")
    cmake_language(EVAL CODE
      "cmake_language(DEFER CALL add_prefix_suffix [[${name}]])"
    )
  endif()
endfunction()

function(add_icu_library name ${ARGN})
  add_icu_target(LIB ${name} ${ARGN})
endfunction()

function(add_icu_executable name ${ARGN})
  add_icu_target(EXE ${name} ${ARGN})
endfunction()

function(add_icu_test name)
  add_icu_target(TEST ${name} NO_INSTALL)

  set(map_lst "$<LIST:TRANSFORM,${tgt_list},REPLACE,(.+),${result}>")
  cmake_language(EVAL CODE
    "cmake_language(DEFER CALL modify_test_env [[${name}]])"
  )
endfunction()

function(install_icu_export name)
  if(NOT ICU_INSTALL_CMAKE_EXPORT)
    return()
  endif()

  install(EXPORT ${name}
    FILE ${name}.cmake
    NAMESPACE ICU::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/ICU
    COMPONENT Development
  )
endfunction()
