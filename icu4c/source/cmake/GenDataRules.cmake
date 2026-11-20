include_guard()

find_package(Python COMPONENTS Interpreter REQUIRED)

function(gen_data_rules)
    set(options "")
    set(one_value_args "")
    set(multi_value_args "")
    cmake_parse_arguments(
        PARSE_ARGN
        arg
        "${options}"
        "${one_value_args}"
        "${multi_value_args}"
    )
    execute_process(
        COMMAND
            "${Python_EXECUTABLE}" -m icutools.databuilder --mode cmake
            --seqmode parallel
            --src_dir ${CMAKE_CURRENT_LIST_DIR} --filter_file 

            "$ENV{ICU_DATA_FILTER_FILE}"
        # "$ENV{ICU_DATA_BUILDTOOL_OPTS}"
        OUTPUT_FILE rules.cmake
        WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
        ENVIRONMENT PYTHONPATH=${ICU_SOURCE_DIR}/python
    )
endfunction()
