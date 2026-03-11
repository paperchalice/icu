add_icu_executable(gensprep)
target_sources(gensprep
  PRIVATE
  gensprep.c store.c
)
target_link_libraries(gensprep
  PRIVATE
  tu
)

configure_file(gensprep.8.in gensprep.8 @ONLY)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/gensprep.8
  DESTINATION ${CMAKE_INSTALL_MANDIR}/man8
  COMPONENT Doc
)
