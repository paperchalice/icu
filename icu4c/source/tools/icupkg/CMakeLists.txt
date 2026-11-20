add_icu_executable(icupkg)
target_link_libraries(icupkg PRIVATE tu)
install_icu_target(icupkg)

configure_file(icupkg.8.in icupkg.8 @ONLY)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/icupkg.8
    DESTINATION ${CMAKE_INSTALL_MANDIR}/man8
    COMPONENT Doc
)
