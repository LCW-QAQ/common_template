# Sonic 子模块的 Config 文件（Header-Only）
#
# find_package(common_templateSonic) 的入口
# 由 CMKMOD_GENERATE_PACKAGE 宏中的 configure_file(@ONLY) 拷贝到构建目录
#
# 职责：加载 Sonic 的 Targets 文件，注册 common_template::Sonic 导入目标
# Sonic 是 INTERFACE 库，无链接依赖，因此不需要 find_dependency()
# 如果将来 Sonic 依赖其他库（如 Eigen3），需在此添加 find_dependency(Eigen3 REQUIRED)

include(CMakeFindDependencyMacro)
include("${CMAKE_CURRENT_LIST_DIR}/common_templateSonicTargets.cmake")
