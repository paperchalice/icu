message(WARNING "icu-config currently is not supported.")
return()

set(UCONFIG_CFLAGS "")
set(UCONFIG_CXXFLAGS "")
set(UCONFIG_CPPFLAGS "")
set(prefix ${CMAKE_INSTALL_PREFIX})
set(VERSION ${PROJECT_VERSION})
set(PACKAGE "ICU")
set(ICULIBSUFFIX ${ICU_WITH_LIBRARY_SUFFIX})
set(UNICODE_VERSION)
set(LIB_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(ICUDATA_CHAR l)
set(libdir ${CMAKE_INSTALL_FULL_LIBDIR})
set(includedir ${CMAKE_INSTALL_FULL_INCLUDEDIR})
set(LIBS "")

if(CMAKE_C_BYTE_ORDER STREQUAL "BIG_ENDIAN")
  set(ICUDATA_CHAR b)
endif()

file(READ ${CMAKE_CURRENT_LIST_DIR}/../common/unicode/uchar.h uchar_h)
string(REGEX MATCH [[#define U_UNICODE_VERSION "([0-9]+\.[0-9]+)"]] UNICODE_VERSION "${uchar_h}")
set(UNICODE_VERSION ${CMAKE_MATCH_1})

configure_file(icu.pc.in icu.pc @ONLY)
configure_file(icu-config.1.in icu-config.1 @ONLY)

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/icu.pc
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
  COMPONENT Development
)

if(CMAKE_HOST_UNIX)
  block()
  set(ECHO_N -n)
  configure_file(Makefile.inc.in Makefile.inc @ONLY)
  endblock()

  # TODO: recognize all cases

  set(mh_file mh-linux)

  if(CMAKE_HOST_APPLE)
    set(mh_file mh-darwin)
  endif()

  add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/icu-config
    COMMAND
    cat ${CMAKE_CURRENT_LIST_DIR}/icu-config-top > icu-config
    COMMAND
    sed -f ${CMAKE_CURRENT_LIST_DIR}/make2sh.sed < ${CMAKE_CURRENT_BINARY_DIR}/Makefile.inc | grep -v '\#M\#' | uniq >> icu-config
    COMMAND
    sed -f ${CMAKE_CURRENT_LIST_DIR}/make2sh.sed < ${CMAKE_CURRENT_LIST_DIR}/${mh_file} | grep -v '\#M\#' | uniq >> icu-config
    COMMAND
    cat ${CMAKE_CURRENT_LIST_DIR}/icu-config-bottom >> icu-config
    DEPENDS
    icu-config-top
    icu-config-bottom
    make2sh.sed
    ${mh_file}
    ${CMAKE_CURRENT_BINARY_DIR}/Makefile.inc
  )
  add_custom_target(icu_config
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/icu-config
  )
  install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/icu-config.1
    DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
    COMPONENT Development
  )
endif()
