add_library(Sonic INTERFACE)
add_library(${PROJECT_NAME}::Sonic ALIAS Sonic)

file(GLOB_RECURSE SONIC_HEADER_FILES *.h *.hpp)

target_sources(Sonic INTERFACE
  FILE_SET HEADERS
    # BASE_DIRS 
    FILES ${SONIC_HEADER_FILES}
)

# install(TARGETS Sonic EXPORT SonicExport
#   FILE_SET HEADERS DESTINATION include/Sonic
# )
# install(EXPORT SonicExport NAMESPACE ${PROJECT_NAME}::
#   DESTINATION lib/cmake/Sonic
# )
CMKMOD_INSTALL(Sonic)
CMKMOD_GENERATE_PACKAGE(Sonic)

# set_target_properties(Sonic
# 	PROPERTIES
# 	VERSION ${SHARED_LIBRARY_VERSION} SOVERSION ${SHARED_LIBRARY_VERSION}
#     # 修改库名称
# 	OUTPUT_NAME ${PROJECT_NAME}Sonic
# 	DEFINE_SYMBOL Sonic_EXPORTS
# )

# target_include_directories(Sonic
# PUBLIC
#     # 在构建时引入的头文件目录
#     $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
#     # 安装时引入的头文件目录
#     $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>
# PRIVATE
#     ${CMAKE_CURRENT_SOURCE_DIR}/src
# )

# CMKMOD_INSTALL(Sonic)
# CMKMOD_GENERATE_PACKAGE(Sonic)