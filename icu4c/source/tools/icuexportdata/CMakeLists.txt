add_icu_executable(icuexportdata)
target_sources(icuexportdata
  PRIVATE
  icuexportdata.cpp
)
target_link_libraries(icuexportdata
  PRIVATE
  tu
)

configure_file(icuexportdata.1.in icuexportdata.1 @ONLY)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/icuexportdata.1
  DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
  COMPONENT Doc
)
