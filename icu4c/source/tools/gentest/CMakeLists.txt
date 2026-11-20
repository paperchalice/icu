if(NOT BUILD_TESTING)
    return()
endif()

add_icu_executable(gentest)
target_link_libraries(gentest tu)
