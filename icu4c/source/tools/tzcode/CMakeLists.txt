if(WIN32)
  add_icu_executable(icuzdump)
  target_sources(icuzdump
    PRIVATE
    icuzdump.cpp
  )
  target_link_libraries(icuzdump
    PRIVATE
    io tu
  )
else()
  # TODO: unix part
endif()
