add_icu_executable(pkgdata)
target_sources(pkgdata
  PRIVATE
  pkgdata.cpp pkgtypes.c
)
target_link_libraries(pkgdata
  PRIVATE
  tu
)

configure_file(pkgdata.1.in pkgdata.1 @ONLY)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/pkgdata.1
  DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
  COMPONENT Doc
)
