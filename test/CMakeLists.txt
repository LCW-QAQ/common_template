file(GLOB_RECURSE ALL_TEST_FILES "*_test.cpp")

foreach(TEST_FILE ${ALL_TEST_FILES})
    get_filename_component(TEST_FILE_NAME ${TEST_FILE} NAME)
    string(REPLACE ".cpp" "" TEST_TARGET ${TEST_FILE_NAME})
    message("  - ${TEST_FILE} --> ${TEST_TARGET}")

    add_executable(${TEST_TARGET} ${TEST_FILE})
    set_target_properties(${TEST_TARGET} PROPERTIES OUTPUT_NAME ${TEST_TARGET})
    # target_link_libraries(${TEST_TARGET} PRIVATE yourlib)

    add_test(NAME ${TEST_TARGET} COMMAND ${TEST_TARGET})
endforeach()
