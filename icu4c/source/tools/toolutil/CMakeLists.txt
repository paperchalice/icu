include(CheckIncludeFile)
check_include_file("elf.h" HAVE_ELF_H)

if(HAVE_ELF_H)
  set(ELF_MACRO U_HAVE_ELF_H=1)
else()
  set(ELF_MACRO "")
endif()

add_icu_library(tu)
target_sources(tu
  PRIVATE
  collationinfo.cpp
  dbgutil.cpp
  denseranges.cpp
  filestrm.cpp
  filetools.cpp
  flagparser.cpp
  package.cpp
  pkg_genc.cpp
  pkg_gencmn.cpp
  pkg_icu.cpp
  pkgitems.cpp
  ppucd.cpp
  swapimpl.cpp
  toolutil.cpp
  ucbuf.cpp
  ucln_tu.cpp
  ucm.cpp
  ucmstate.cpp
  udbgutil.cpp
  unewdata.cpp
  uoptions.cpp
  uparse.cpp
  writesrc.cpp
  xmlparser.cpp
)
target_compile_definitions(tu
  PRIVATE
  U_TOOLUTIL_IMPLEMENTATION
  PUBLIC
  ${ELF_MACRO}
)
target_include_directories(tu
  PRIVATE
  ../../i18n
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:>
)
target_link_libraries(tu
  PUBLIC
  uc in
)
