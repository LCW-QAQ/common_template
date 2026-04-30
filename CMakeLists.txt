cmake_minimum_required(VERSION 3.5)
project(common_template VERSION 0.1.0 LANGUAGES C CXX)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 基础设置
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 用于控制是否启用库的安装与导出（当项目仅作为可执行程序而不提供库时关闭）
set(MY_ENABLE_LIB ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 将项目自身的 cmake/ 目录加入模块搜索路径，以便 include() 能找到 common_templateMacros.cmake
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

enable_testing()

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 库安装与导出（find_package 支持）
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# 整体思路：
#   顶层负责生成 顶层Config + ConfigVersion（入口文件，按 COMPONENTS 分发到子模块）
#   子模块各自负责生成 子模块Config + Targets（具体目标的编译/链接信息）
#
# 安装后的文件布局：
#   <prefix>/lib/cmake/common_template/
#     ├── common_templateConfig.cmake              ← 顶层入口（支持 COMPONENTS 按需加载）
#     ├── common_templateConfigVersion.cmake       ← 版本兼容性检查
#     ├── common_templateCoreTargets.cmake         ← Core 目标的编译/链接元信息
#     ├── common_templateCoreConfig.cmake          ← Core Config
#     ├── common_templateCoreConfigVersion.cmake
#     ├── common_templateSonicTargets.cmake        ← Sonic 目标的元信息
#     ├── common_templateSonicConfig.cmake         ← Sonic Config
#     └── common_templateSonicConfigVersion.cmake
#

# 引入可复用的 install/package 宏（CMKMOD_INSTALL / CMKMOD_GENERATE_PACKAGE）
include(common_templateMacros)

if(MY_ENABLE_LIB)
  # GNUInstallDirs 定义跨平台标准路径变量：
  #   CMAKE_INSTALL_BINDIR     = bin
  #   CMAKE_INSTALL_LIBDIR     = lib（部分 64 位系统为 lib64）
  #   CMAKE_INSTALL_INCLUDEDIR = include
  include(GNUInstallDirs)

  include(CMakePackageConfigHelpers)

  # 从 .cmake.in 模板生成顶层 Config 文件
  # 该文件是 find_package(common_template) 的入口，内部遍历 COMPONENTS 逐一加载子模块 Config
  configure_package_config_file(
    ${PROJECT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}Config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
  )

  # 版本文件：支持 find_package(common_template 0.1.0 EXACT REQUIRED) 语法
  write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
  )

  # 安装顶层 Config + ConfigVersion（子模块的 Config/Targets 由各自的宏负责安装）
  install(
    FILES
      ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}Config.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
  )
endif()

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 子目录
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

add_subdirectory(src)
add_subdirectory(test)
add_subdirectory(modules/Core)
add_subdirectory(modules/Sonic)
