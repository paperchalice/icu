include_guard()

include(ExternalProject)

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

set(need_bootstrap ON)
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
    ExternalProject_Add(
        ICU_NATIVE
        SOURCE_DIR ${PROJECT_SOURCE_DIR}
        ${generator}
        CMAKE_ARGS
            -DICU_IS_BOOTSTRAPPING=ON -DCMAKE_INSTALL_PREFIX=${host_icu_prefix}
            -DCMAKE_BUILD_TYPE=Release
        USES_TERMINAL_CONFIGURE ON
        USES_TERMINAL_BUILD ON
        BUILD_ALWAYS ON
        BUILD_COMMAND
            ${CMAKE_COMMAND} --build ../ICU_NATIVE-build ${config_option}
        INSTALL_COMMAND
            ${CMAKE_COMMAND} --install ../ICU_NATIVE-build --component Runtime
            ${config_option}
    )

    set(ICU_NATIVE_TOOL_DIR ${host_icu_prefix}/bin)
endif()

set(ICU_TOOL_PREFIX ${ICU_NATIVE_TOOL_DIR}/)
