if(ICU_DISABLE_ICUIO)
  return()
endif()

set(io_srcs
  locbund.cpp
  sprintf.cpp
  sscanf.cpp
  ucln_io.cpp
  ufile.cpp
  ufmt_cmn.cpp
  uprintf.cpp
  uprntf_p.cpp
  uscanf.cpp
  uscanf_p.cpp
  ustdio.cpp
  ustream.cpp
)
add_icu_library(io EXPORT ICUioTargets)
install_icu_export(ICUioTargets)
target_sources(io
  PRIVATE
  ${io_srcs}
)
target_sources(io
  PUBLIC
  FILE_SET HEADERS
  FILES
  unicode/ustdio.h
  unicode/ustream.h
)

target_compile_definitions(io
  PRIVATE
  U_IO_IMPLEMENTATION
)
target_link_libraries(io
  PRIVATE
  in
  PUBLIC
  uc
)
