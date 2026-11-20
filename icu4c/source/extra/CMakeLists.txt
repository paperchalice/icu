if(ICU_DISABLE_EXTRAS)
    return()
endif()

set(CMAKE_FOLDER extra)

add_subdirectory(scrptrun)
add_subdirectory(uconv)
