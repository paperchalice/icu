add_icu_executable(gencfu)
target_sources(gencfu
  PRIVATE
  gencfu.cpp
)
target_link_libraries(gencfu
  PRIVATE
  tu
)

configure_file(gencfu.1.in gencfu.1 @ONLY)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/gencfu.1
  DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
  COMPONENT Doc
)
