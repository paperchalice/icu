add_icu_perf_test(strsrchperf)
target_sources(strsrchperf
  PRIVATE
  strsrchperf.cpp
)
target_link_libraries(strsrchperf
  PRIVATE
  ctestfw in
)
