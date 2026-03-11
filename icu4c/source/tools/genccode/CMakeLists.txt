add_icu_executable(genccode)
target_sources(genccode
  PRIVATE
  genccode.c
)
target_link_libraries(genccode
  PRIVATE
  tu
)

configure_file(genccode.8.in genccode.8 @ONLY)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/genccode.8
  DESTINATION ${CMAKE_INSTALL_MANDIR}/man8
  COMPONENT Doc
)
