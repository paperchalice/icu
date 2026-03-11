add_icu_perf_test(collperf)
target_sources(collperf
  PRIVATE
  collperf.cpp
)
target_link_libraries(collperf
  PRIVATE
  ctestfw tu
)
