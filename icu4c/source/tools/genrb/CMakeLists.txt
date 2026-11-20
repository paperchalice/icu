add_icu_executable(genrb)
target_link_libraries(genrb PRIVATE tu)
install_icu_target(genrb)

configure_file(genrb.1.in genrb.1 @ONLY)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/genrb.1
    DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
    COMPONENT Doc
)

if(NOT ICU_IS_BOOTSTRAPPING)
    add_icu_executable(derb NO_SOURCES)
    target_sources(derb PRIVATE derb.cpp)
    target_link_libraries(derb PRIVATE io tu)

    configure_file(derb.1.in derb.1 @ONLY)
    install(
        FILES ${CMAKE_CURRENT_BINARY_DIR}/derb.1
        DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
        COMPONENT Doc
    )
endif()
