add_icu_executable(gennorm2)
target_sources(gennorm2
  PRIVATE
  extradata.cpp gennorm2.cpp n2builder.cpp norms.cpp
)
target_link_libraries(gennorm2
  PRIVATE
  tu
)
