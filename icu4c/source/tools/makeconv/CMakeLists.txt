add_icu_executable(makeconv)
target_sources(makeconv
  PRIVATE
  gencnvex.c genmbcs.cpp makeconv.cpp ucnvstat.c
)
target_link_libraries(makeconv
  PRIVATE
  tu
)

configure_file(makeconv.1.in makeconv.1 @ONLY)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/makeconv.1
  DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
  COMPONENT Doc
)
