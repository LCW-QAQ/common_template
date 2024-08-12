aux_source_directory(src SRC_FILES)

add_library(Core ${SRC_FILES})
add_library(${PROJECT_NAME}::Core ALIAS Core)
set_target_properties(Core
	PROPERTIES
	VERSION ${SHARED_LIBRARY_VERSION} SOVERSION ${SHARED_LIBRARY_VERSION}
    # 修改库名称
	OUTPUT_NAME ${PROJECT_NAME}Core
	DEFINE_SYMBOL Core_EXPORTS
)

target_include_directories(Core
PUBLIC
    # 在构建时引入的头文件目录
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    # 安装时引入的头文件目录
    $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>
PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

CMKMOD_INSTALL(Core)
CMKMOD_GENERATE_PACKAGE(Core)
