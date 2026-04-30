# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 可复用的 install / package 宏
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# 使用方式：子模块 CMakeLists.txt 中调用
#   CMKMOD_INSTALL(<target_name>)         — 安装头文件 + 目标产物
#   CMKMOD_GENERATE_PACKAGE(<target_name>) — 生成 Config/ConfigVersion/Targets
#
# 之所以用 macro 而非 function：宏不创建新的变量作用域，
# ${CMAKE_CURRENT_SOURCE_DIR}、${PROJECT_NAME} 等变量直接引用调用者的值
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 安装头文件 + 目标产物（库文件/可执行文件）
macro(CMKMOD_INSTALL target_name)
    # ── 安装头文件 ──
    # 末尾的 / 很关键：表示仅拷贝 include/ 目录下的内容，而非 include 目录本身
    # 例如 include/sonic/allocator.h → 安装到 <prefix>/include/common_template/sonic/allocator.h
    install(
      DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/
      DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
    )

    # ── 安装目标产物 + 导出信息 ──
    install(
      TARGETS ${target_name}
      # EXPORT 名称是导出集的唯一标识，不是文件名
      # 后续 CMKMOD_GENERATE_PACKAGE 中的 install(EXPORT ...) 会引用这个名称
      EXPORT "${target_name}Targets"
      LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
      ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
      RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
      BUNDLE DESTINATION ${CMAKE_INSTALL_BINDIR}
      # INCLUDES DESTINATION 的作用：为导出目标设置 INTERFACE_INCLUDE_DIRECTORIES 属性
      # 消费端 find_package 后链接该目标时，会自动获得此路径作为头文件搜索路径
      # 注意：这仅影响安装后的消费端，构建树内的头文件路径需要由 target_include_directories 提供
      INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
      FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )
endmacro()

# 生成并安装 Config / ConfigVersion / Targets 文件
macro(CMKMOD_GENERATE_PACKAGE target_name)
    # 版本文件：让消费端支持 find_package(ProjectName 0.1.0 REQUIRED) 版本语法
    write_basic_package_version_file(
      "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}ConfigVersion.cmake"
      VERSION ${PROJECT_VERSION}
      COMPATIBILITY AnyNewerVersion
    )

    # 从模块的 cmake/ 子目录拷贝 Config 文件
    # @ONLY 表示只替换 @var@ 形式的变量，不替换 ${var} 形式
    # 避免将 CMake 语法变量（如 ${CMAKE_CURRENT_LIST_DIR}）意外展开
    configure_file(
      "${CMAKE_CURRENT_LIST_DIR}/cmake/${PROJECT_NAME}${target_name}Config.cmake"
      "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}Config.cmake"
      @ONLY
    )

    # 导出 Targets 文件：包含目标的所有编译/链接属性
    # NAMESPACE 使得消费端通过 common_template::Core 形式引用目标
    install(
      EXPORT "${target_name}Targets"
      FILE "${PROJECT_NAME}${target_name}Targets.cmake"
      NAMESPACE "${PROJECT_NAME}::"
      DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
    )

    # 安装子模块的 Config + ConfigVersion 文件
    install(
      FILES
        "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}Config.cmake"
        "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}ConfigVersion.cmake"
      DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
    )
endmacro()
