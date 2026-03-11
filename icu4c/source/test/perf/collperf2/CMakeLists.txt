add_icu_perf_test(collperf2)
target_sources(collperf2
  PRIVATE
  collperf2.cpp
)
target_link_libraries(collperf2
  PRIVATE
  ctestfw tu
)
