add_icu_executable(gencfu)
target_link_libraries(gencfu PRIVATE uc tu)
install(TARGETS gencfu)

configure_file(gencfu.1.in gencfu.1 @ONLY)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/gencfu.1
    DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
    COMPONENT Doc
)
install_icu_target(gencfu)
