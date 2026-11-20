add_icu_executable(gencmn)
target_link_libraries(gencmn PRIVATE tu)
install_icu_target(gencmn)

configure_file(gencmn.8.in gencmn.8 @ONLY)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/gencmn.8
    DESTINATION ${CMAKE_INSTALL_MANDIR}/man8
    COMPONENT Doc
)
