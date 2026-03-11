set(tgt_name data)
set(tgt_alias dt)
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
  set(tgt_name dt)
  set(tgt_alias data)
endif()

add_icu_library(${tgt_name} EXPORT ICU${tgt_name}Targets)
install_icu_export(ICU${tgt_name}Targets)
target_sources(${tgt_name}
  PRIVATE
  stubdata.cpp
)
target_include_directories(${tgt_name}
  PRIVATE ../common
)

add_library(${tgt_alias} ALIAS ${tgt_name})
