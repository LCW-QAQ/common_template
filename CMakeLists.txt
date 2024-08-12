cmake_minimum_required(VERSION 3.5)
project(common_template VERSION 0.1.0 LANGUAGES C CXX)

# 用户自定义变量
set(MY_ENABLE_LIB ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 引入自定义的cmake模块
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

enable_testing()
# 引入通用宏
# 主要用于导出Config、Targets文件，供第三方应用使用
include(common_templateMacros)

if(MY_ENABLE_LIB)
  # 引入后会自动设置了 CMAKE_INSTALL_BINDIR、CMAKE_INSTALL_LIBDIR、CMAKE_INSTALL_INCLUDEDIR 等变量，
  # 然后通过 install 命令指定了可执行文件、库文件和头文件的安装路径。这样做使得项目更容易在不同的系统上进行移植和安装。
  # 在linux上CMAKE_INSTALL_PREFIX=，windows上则为C:/Program Files (x86)/${PROJECT_NAME}或C:/Program Files/${PROJECT_NAME}
  include(GNUInstallDirs)

  # 引入用于生成CMake Config文件命令
  include(CMakePackageConfigHelpers)

  # 生成项目的config文件，供第三方应用引入
  # 在${PROJECT_NAME}Config.cmake.in中，编写查找项目其他子组件的逻辑
  configure_package_config_file(
    ${PROJECT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}Config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
  )
  # 导出版本文件
  write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
  )
  # 指定整个项目Config文件的安装路径
  # 该Config文件负责搜索所有子模块
  install(
    FILES
      ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}Config.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
  )
endif()

add_subdirectory(src)
add_subdirectory(test)
add_subdirectory(modules/Core)