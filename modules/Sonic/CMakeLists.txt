# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Header-Only 子模块：Sonic（INTERFACE 库）
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# INTERFACE 库的特点：
#   - 无源文件（.cpp），无编译产物（.a / .so）
#   - 所有属性必须使用 INTERFACE 可见性（不能用 PUBLIC / PRIVATE）
#   - INTERFACE 含义：自己不用，仅传播给链接它的目标
#
# 安装后消费端使用方式：
#   find_package(common_template REQUIRED COMPONENTS Sonic)
#   target_link_libraries(myApp PRIVATE common_template::Sonic)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# INTERFACE 关键字表示此库不编译任何源码，仅作为属性传播的载体
add_library(Sonic INTERFACE)
add_library(${PROJECT_NAME}::Sonic ALIAS Sonic)

# TODO: 当前缺少 target_include_directories，构建树内消费者链接 common_template::Sonic
# 时不会自动获得头文件路径。建议补充：
#
# target_include_directories(Sonic INTERFACE
#     $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
#     $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
# )
#
# 补充后：
#   - 构建树内：target_link_libraries(app PRIVATE common_template::Sonic) 自动获得头文件路径
#   - 安装后：已通过 CMKMOD_INSTALL 中 install(TARGETS ... INCLUDES DESTINATION ...) 覆盖

CMKMOD_INSTALL(Sonic)
CMKMOD_GENERATE_PACKAGE(Sonic)
