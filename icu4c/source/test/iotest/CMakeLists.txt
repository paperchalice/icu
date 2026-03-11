if(ICU_DISABLE_ICUIO)
  return()
endif()

add_icu_test(iotest)
target_sources(iotest
  PRIVATE
  filetst.c
  iotest.cpp
  stream.cpp
  strtst.c
  trnstst.c
)
target_link_libraries(iotest
  PRIVATE
  ctestfw io in tu
)
add_dependencies(iotest testdata)
