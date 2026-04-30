# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 自动测试注册
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# 约定：所有测试文件以 _test.cpp 结尾
# 自动扫描当前目录下所有匹配文件，为每个文件生成独立的测试可执行目标
# 例如：core_test.cpp → 可执行文件 core_test → 测试用例 core_test
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

file(GLOB_RECURSE ALL_TEST_FILES "*_test.cpp")

foreach(TEST_FILE ${ALL_TEST_FILES})
    get_filename_component(TEST_FILE_NAME ${TEST_FILE} NAME)
    string(REPLACE ".cpp" "" TEST_TARGET ${TEST_FILE_NAME})
    message("  - ${TEST_FILE} --> ${TEST_TARGET}")

    add_executable(${TEST_TARGET} ${TEST_FILE})
    set_target_properties(${TEST_TARGET} PROPERTIES OUTPUT_NAME ${TEST_TARGET})
    # TODO: 取消注释并替换为实际的库目标
    # target_link_libraries(${TEST_TARGET} PRIVATE common_template::Core)

    add_test(NAME ${TEST_TARGET} COMMAND ${TEST_TARGET})
endforeach()
