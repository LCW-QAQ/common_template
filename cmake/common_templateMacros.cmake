# 用户安装头文件、库文件的安装路径配置
macro(CMKMOD_INSTALL target_name)    
    # 头文件目录安装路径
    install(
      # 最后带/表示仅拷贝目录下的内容，否则会将整个目录拷贝
      DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/
      DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )

    # 库与二进制文件的安装路径
    install(
      TARGETS ${target_name}
      # 指定导出对象名称（不是Targets文件名称，可以当作Targets文件的唯一标识）
      EXPORT "${target_name}Targets"
      # 动态库安装路径
      LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
      # 静态库安装路径
      ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
      # 可执行文件安装路径
      RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
      # 打包号的app文件路径
      BUNDLE DESTINATION ${CMAKE_INSTALL_BINDIR}
      # 头文件路径
      INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
      # INTERFACE库头文件路径
      FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )
endmacro()

macro(CMKMOD_GENERATE_PACKAGE target_name)
    # 导出版本文件
    write_basic_package_version_file(
      "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}ConfigVersion.cmake"
      VERSION ${PROJECT_VERSION}
      COMPATIBILITY AnyNewerVersion
    )
    # 生成Config文件
    configure_file(
      "${CMAKE_CURRENT_LIST_DIR}/cmake/${PROJECT_NAME}${target_name}Config.cmake"
      "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}Config.cmake"
      # @COPYONLY 仅拷贝文件，不替换文件内部任何变量
      @ONLY # 替换输入文件内部@var_name@变量，不替换${var_name}变量
    )
    # 下面的命令也可以生成Config文件，同时指定Config文件安装时的路径
    # 注意该命令第一个参数不能为空，即必须指定模板文件，当不需要使用模板文件时，请使用configure_file命令
    # configure_package_config_file(
    #     ${PROJECT_SOURCE_DIR}/cmake/${PROJECT_NAME}CoreConfig.cmake.in
    #     ${PROJECT_NAME}CoreConfig.cmake
    #     INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
    # )
    
    # 指定Targets文件的安装路径
    install(
      EXPORT "${target_name}Targets"
      FILE "${PROJECT_NAME}${target_name}Targets.cmake"
      NAMESPACE "${PROJECT_NAME}::"
      DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
    )

    # 指定Config文件安装路径
    install(
      FILES
        "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}Config.cmake"
        "${CMAKE_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}${target_name}ConfigVersion.cmake"
      DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
    )
endmacro()
