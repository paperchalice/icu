if(NOT ICU_INSTALL_CMAKE_EXPORT)
  return()
endif()

include(CMakePackageConfigHelpers)

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/ICUConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion
)

configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/ICUConfig.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/ICU
)

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/ICUConfig.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/ICUConfigVersion.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/ICU
  COMPONENT Development
)
