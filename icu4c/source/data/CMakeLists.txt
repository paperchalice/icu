if(CMAKE_C_BYTE_ORDER STREQUAL "BIG_ENDIAN")
  set(icudata_char "b")
else()
  set(icudata_char "l")
endif()

set(U_ICUDATA_NAME icudt${PROJECT_VERSION_MAJOR})
set(ICUPKG ${U_ICUDATA_NAME}${icudata_char})

build_icu_data(icudata
  OUT_DIR build/${ICUPKG}
)

build_icu_data_pkg(${ICUPKG}
  ENTRYPOINT ${U_ICUDATA_NAME}
  LIBNAME ${U_ICUDATA_NAME}
  DATA_NAME icudata
  MODE common
  OUT_DEP obj_dep
  SRC_DIR build/${ICUPKG}
  DST_DIR build/${ICUPKG}
)

add_custom_command(OUTPUT data.inc
  COMMAND
  ${CMAKE_COMMAND} -E bin2c
  -- ${obj_dep} data.inc
  DEPENDS
  ${obj_dep}
)

set(tgt_name data)
set(alias_name dt)

if(CMAKE_SYSTEM_NAME MATCHES "^Windows")
  set(tgt_name dt)
  set(alias_name data)
endif()

if(NOT ICU_WITH_DATA_PACKAGING STREQUAL "archive")
  if(ICU_WITH_DATA_PACKAGING STREQUAL "library")
    set(lib_kind SHARED)
  elseif(ICU_WITH_DATA_PACKAGING STREQUAL "static")
    set(lib_kind STATIC)
  endif()
  add_icu_library(${tgt_name} ${lib_kind} EXPORT ICU${tgt_name}Targets)
  add_library(${alias_name} ALIAS ${tgt_name})
  target_sources(${tgt_name}
    PRIVATE
    data.c
  )
  target_sources(${tgt_name}
    PRIVATE
    FILE_SET HEADERS
    BASE_DIRS ${CMAKE_CURRENT_BINARY_DIR}
    FILES
    ${CMAKE_CURRENT_BINARY_DIR}/data.inc
  )
  install_icu_export(ICU${tgt_name}Targets)
  target_include_directories(${tgt_name}
    PRIVATE
    ../common
    ${CMAKE_CURRENT_BINARY_DIR}
  )
else()
  install(FILES
    ${CMAKE_CURRENT_LIST_DIR}/out/tmp/${ICUPKG}.dat
    COMPONENT Runtime
    DESTINATION ${CMAKE_INSTALL_DATADIR}/icu${ICU_WITH_LIBRARY_SUFFIX}/${PROJECT_VERSION}
  )
endif()
