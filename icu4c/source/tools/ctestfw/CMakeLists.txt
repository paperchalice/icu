add_icu_library(ctestfw NO_INSTALL)
target_sources(ctestfw
  PRIVATE
  ctest.c
  datamap.cpp
  testdata.cpp
  tstdtmod.cpp
  ucln_ct.c
  uperf.cpp
)
set_target_properties(ctestfw
  PROPERTIES
  OUTPUT_NAME test
)
target_sources(ctestfw
  PUBLIC
  FILE_SET HEADERS
  FILES
  unicode/ctest.h
  unicode/datamap.h
  unicode/testdata.h
  unicode/testlog.h
  unicode/testtype.h
  unicode/tstdtmod.h
  unicode/uperf.h
  unicode/utimer.h
)
target_compile_definitions(ctestfw
  PRIVATE
  T_CTEST_IMPLEMENTATION
)
target_link_libraries(ctestfw
  PUBLIC
  uc tu
)
