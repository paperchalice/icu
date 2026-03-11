add_icu_perf_test(charperf)
target_sources(charperf
  PRIVATE
  charperf.cpp
)
target_link_libraries(charperf
  PRIVATE
  ctestfw tu
)
