add_icu_executable(gentest)
target_sources(gentest
  PRIVATE
  genres32.c gentest.c
)
target_link_libraries(gentest
  PRIVATE
  tu
)
