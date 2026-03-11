add_icu_executable(genbrk)
target_sources(genbrk
  PRIVATE
  genbrk.cpp
)
target_link_libraries(genbrk
  PRIVATE
  tu
)

configure_file(genbrk.1.in genbrk.1 @ONLY)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/genbrk.1
  DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
  COMPONENT Doc
)
