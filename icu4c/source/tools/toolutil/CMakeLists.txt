include(CheckIncludeFile)
check_include_file("elf.h" HAVE_ELF_H)

if(HAVE_ELF_H)
    set(ELF_MACRO U_HAVE_ELF_H=1)
else()
    set(ELF_MACRO "")
endif()

add_icu_library(tu)
install_icu_target(tu)
target_compile_definitions(
    tu
    PRIVATE U_TOOLUTIL_IMPLEMENTATION
    PUBLIC ${ELF_MACRO}
)
target_include_directories(
    tu
    PRIVATE ../../i18n
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> $<INSTALL_INTERFACE:>
)
target_link_libraries(tu PUBLIC uc in)
