include(AddICUData)

add_icu_data(uconvmsg
  SOURCES
  resources/fr.txt
  resources/root.txt
)

add_icu_executable(uconv)
target_compile_definitions(uconv PRIVATE UCONVMSG_LINK)
target_link_libraries(uconv PRIVATE in uconvmsg)
