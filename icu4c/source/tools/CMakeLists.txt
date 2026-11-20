if(ICU_DISABLE_TOOLS)
    return()
endif()

set(CMAKE_FOLDER tools)

add_subdirectory(toolutil)

# for configure_file
set(VERSION ${ICU_VERSION})
set(PACKAGE icu)
set(thepkgicudatadir ${CMAKE_INSTALL_DATAROOTDIR})

add_subdirectory(genbrk)
add_subdirectory(gencfu)
add_subdirectory(gencnval)
add_subdirectory(gendict)
add_subdirectory(gennorm2)
add_subdirectory(genrb)
add_subdirectory(gensprep)
add_subdirectory(icupkg)
add_subdirectory(makeconv)
add_subdirectory(pkgdata)

if(NOT ICU_IS_BOOTSTRAPPING)
    add_subdirectory(escapesrc)
    add_subdirectory(genccode)
    add_subdirectory(gencmn)
    add_subdirectory(gencolusb)
    add_subdirectory(icuexportdata)
    add_subdirectory(icuinfo)
    add_subdirectory(icuswap)
endif()

if(BUILD_TESTING)
    add_subdirectory(ctestfw)
    add_subdirectory(gentest)
endif()
