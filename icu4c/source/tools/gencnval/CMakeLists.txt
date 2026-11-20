add_icu_executable(gencnval)
target_link_libraries(gencnval PRIVATE tu)
install_icu_target(gencnval)

configure_file(gencnval.1.in gencnval.1 @ONLY)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/gencnval.1
    DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
    COMPONENT Doc
)
