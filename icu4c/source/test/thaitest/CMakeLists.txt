add_icu_test(thaitest)
target_sources(thaitest PRIVATE thaitest.cpp)
target_link_libraries(thaitest PRIVATE uc)
