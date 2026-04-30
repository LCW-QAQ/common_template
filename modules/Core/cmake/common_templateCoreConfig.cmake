# Core 子模块的 Config 文件
#
# find_package(common_templateCore) 的入口
# 由 CMKMOD_GENERATE_PACKAGE 宏中的 configure_file(@ONLY) 拷贝到构建目录
#
# 职责：加载 Core 的 Targets 文件，注册 common_template::Core 导入目标
# 如果 Core 有外部依赖，需要在此文件中用 find_dependency() 声明
# 例如：find_dependency(Boost REQUIRED COMPONENTS system)

include(CMakeFindDependencyMacro)
include("${CMAKE_CURRENT_LIST_DIR}/common_templateCoreTargets.cmake")
