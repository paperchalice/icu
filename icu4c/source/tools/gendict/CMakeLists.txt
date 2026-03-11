add_icu_executable(gendict)
target_sources(gendict
  PRIVATE
  gendict.cpp
)
target_link_libraries(gendict
  PRIVATE
  tu
)

configure_file(gendict.1.in gendict.1 @ONLY)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/gendict.1
  DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
  COMPONENT Doc
)
