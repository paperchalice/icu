if(ICU_DISABLE_ICUIO)
    return()
endif()

add_icu_library(io)
target_sources(
    io
    PUBLIC FILE_SET HEADERS FILES unicode/ustdio.h unicode/ustream.h
)

target_compile_definitions(io PRIVATE U_IO_IMPLEMENTATION)
target_link_libraries(io PRIVATE in PUBLIC uc)
install_icu_target(io)
