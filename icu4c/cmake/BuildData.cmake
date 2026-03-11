include_guard()

if(ICU_IS_BOOTSTRAPPING)
  return()
endif()

include(ExternalProject)

# setup native icu
find_package(ICU QUIET)

set(need_bootstrap ON)

if(ICU_FOUND)
  set(required_tools
    gencfu
    gencnval
    icupkg
    makeconv
    genbrk
    gensprep
    gendict
    genrb
    pkgdata
  )

  set(need_bootstrap OFF)

  foreach(tool ${required_tools})
    string(TOUPPER ${tool} tool)

    if(NOT ICU_${tool}_EXECUTABLE)
      set(need_bootstrap ON)
    endif()
  endforeach()
endif()

if(need_bootstrap)
  set(generator "")
  find_program(ninja_available ninja)

  # prefer ninja for speed
  if(ninja_available)
    set(generator CMAKE_GENERATOR Ninja)
  endif()

  get_cmake_property(generator_is_multi_config GENERATOR_IS_MULTI_CONFIG)

  set(config_option "")

  if(generator_is_multi_config AND NOT ninja_available)
    set(config_option --config Release)
  endif()

  set(host_icu_prefix ${CMAKE_CURRENT_BINARY_DIR}/NATIVE)
  ExternalProject_Add(ICU_NATIVE
    SOURCE_DIR ${PROJECT_SOURCE_DIR}
    ${generator}
    CMAKE_ARGS
    -DICU_IS_BOOTSTRAPPING=ON
    -DCMAKE_INSTALL_PREFIX=${host_icu_prefix}
    -DCMAKE_BUILD_TYPE=Release
    USES_TERMINAL_CONFIGURE ON
    USES_TERMINAL_BUILD ON
    BUILD_COMMAND cmake --build ../ICU_NATIVE-build ${config_option}
    INSTALL_COMMAND cmake --install ../ICU_NATIVE-build --component Runtime ${config_option}
  )

  set(ICU_NATIVE_TOOL_DIR ${host_icu_prefix}/bin)
else()
  cmake_path(GET ICU_GENCFU_EXECUTABLE PARENT_PATH ICU_NATIVE_TOOL_DIR)
endif()

find_package(Python REQUIRED COMPONENTS Interpreter)

if(CMAKE_C_BYTE_ORDER STREQUAL "BIG_ENDIAN")
  set(icudata_char "b")
else()
  set(icudata_char "l")
endif()

function(build_icu_data data_name)
  set(options "")
  set(one_val_args
    OUTPUT
    OUT_LST
    OUT_DIR TMP_DIR
    FILTER_FILE
  )
  set(mult_val_args "")
  cmake_parse_arguments(arg
    "${options}" "${one_val_args}" "${mult_val_args}"
    ${ARGN}
  )

  cmake_path(CONVERT "$ENV{PYTHONPATH}" TO_CMAKE_PATH_LIST pythonpath)
  list(APPEND pythonpath ${PROJECT_SOURCE_DIR}/source/python)
  cmake_path(CONVERT "${pythonpath}" TO_NATIVE_PATH_LIST pythonpath)

  set(default_out ${CMAKE_CURRENT_LIST_DIR}/out)
  set(out_dir ${default_out}/build)
  set(tmp_dir ${default_out}/tmp)

  foreach(dir in OUT_DIR TMP_DIR)
    string(TOLOWER ${dir} lower_dir)

    if(arg_${dir})
      cmake_path(IS_ABSOLUTE arg_${dir} is_dir_absolute)

      if(is_dir_absolute)
        set(${lower_dir} ${arg_${dir}})
      else()
        set(${lower_dir} ${default_out}/${arg_${dir}})
      endif()
    endif()
  endforeach()

  if(need_bootstrap)
    set(dep DEPENDS ICU_NATIVE)
  endif()

  add_custom_command(OUTPUT ${tmp_dir}/${data_name}.lst
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    COMMAND
    ${CMAKE_COMMAND} -E env "PYTHONPATH=${pythonpath}" --
    ${Python_EXECUTABLE} -m icutools.databuilder
    --mode cmake-exec
    --src_dir ${CMAKE_CURRENT_LIST_DIR}
    --out_dir ${out_dir}
    --tmp_dir ${tmp_dir}
    --tool_dir ${ICU_NATIVE_TOOL_DIR}
    ${dep}
    USES_TERMINAL
  )
endfunction()

function(build_icu_data_pkg name)
  set(options "")
  set(one_val_args
    ENTRYPOINT
    LIBNAME
    OUTPUT
    DATA_NAME
    OUT_DEP
    DST_DIR SRC_DIR TMP_DIR LST_DIR
    MODE
  )
  set(mult_val_args "")
  cmake_parse_arguments(arg
    "${options}" "${one_val_args}" "${mult_val_args}"
    ${ARGN}
  )

  set(default_out ${CMAKE_CURRENT_LIST_DIR}/out)
  set(tmp_dir ${default_out}/tmp)
  set(dst_dir ${default_out}/build)
  set(src_dir ${default_out}/build)
  set(lst_dir ${default_out}/tmp)

  foreach(dir in DST_DIR SRC_DIR TMP_DIR LST_DIR)
    string(TOLOWER ${dir} lower_dir)

    if(arg_${dir})
      cmake_path(IS_ABSOLUTE arg_${dir} is_dir_absolute)

      if(is_dir_absolute)
        set(${lower_dir} ${arg_${dir}})
      else()
        set(${lower_dir} ${default_out}/${arg_${dir}})
      endif()
    endif()
  endforeach()

  find_program(PKGDATA pkgdata
    HINTS ${ICU_NATIVE_TOOL_DIR}
  )

  if(WIN32)
    set(win_pkgdata_flags -f)

    if(CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
      list(APPEND win_pkgdata_flags -u)
    endif()

    set(x86_names X86 i386 i486 i586 i686)

    if(CMAKE_C_COMPILER_ARCHITECTURE_ID IN_LIST x86_names)
      list(APPEND win_pkgdata_flags -a X86)
    endif()

    set(x64_names x64 x86_64)

    if(CMAKE_C_COMPILER_ARCHITECTURE_ID IN_LIST x64_names)
      list(APPEND win_pkgdata_flags -a X64)
    endif()

    set(arm_names ARMV4I ARMV5I ARMV7 armv7)

    if(CMAKE_C_COMPILER_ARCHITECTURE_ID IN_LIST arm_names)
      list(APPEND win_pkgdata_flags -a ARM)
    endif()

    set(arm64_names ARM64 ARM64EC aarch64)

    if(CMAKE_C_COMPILER_ARCHITECTURE_ID IN_LIST arm64_names)
      list(APPEND win_pkgdata_flags -a ARM)
    endif()
  endif()

  set(mode_options)

  if(arg_MODE)
    set(mode_options -m ${arg_MODE})
  else()
    set(arg_MODE common)
  endif()

  set(data_name ${arg_DATA_NAME})

  set(entrypoint_options "")

  if(arg_ENTRYPOINT)
    set(entrypoint_options -e ${arg_ENTRYPOINT})
  endif()

  set(libname_options "")

  if(arg_LIBNAME)
    set(libname_options -L ${arg_LIBNAME})
  endif()

  if(arg_MODE STREQUAL "common")
    set(out_dep ${dst_dir}/${name}.dat)
  else()
    set(out_dep ${tmp_dir}/${name}_dat${CMAKE_C_OUTPUT_EXTENSION})
  endif()

  if(arg_OUT_DEP)
    set(${arg_OUT_DEP} ${out_dep} PARENT_SCOPE)
  endif()

  add_custom_command(OUTPUT ${out_dep}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND
    ${PKGDATA}
    ${win_pkgdata_flags}
    ${entrypoint_options} -v ${mode_options} -c
    -p ${name} ${lib_name_opt}
    -T ${tmp_dir} -d ${dst_dir} -s ${src_dir}
    ${lst_dir}/${data_name}.lst
    DEPENDS ${lst_dir}/${data_name}.lst
    USES_TERMINAL
  )
endfunction()
