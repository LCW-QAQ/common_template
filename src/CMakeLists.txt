aux_source_directory(. SRC_FILES)

# Enable Qt
# list(APPEND CMAKE_PREFIX_PATH "e:/software/Qt/Qt5.12.7/5.12.7/mingw73_64")
# set(CMAKE_AUTOUIC ON)
# set(CMAKE_AUTOMOC ON)
# set(CMAKE_AUTORCC ON)

add_executable(${PROJECT_NAME}_main ${SRC_FILES})
set_target_properties(
  ${PROJECT_NAME}_main PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin
  # LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib
)

target_compile_options(
  ${PROJECT_NAME}_main PRIVATE 
  -mpclmul
  -mfma
)

target_include_directories(
  ${PROJECT_NAME}_main PRIVATE 
  ${PROJECT_SOURCE_DIR}/include
  ${Boost_INCLUDE_DIR}
)

# require lib:
find_package(Boost REQUIRED COMPONENTS)
find_package(jsoncpp REQUIRED)
find_package(TBB REQUIRED)
find_package(range-v3 REQUIRED)
find_package(yaml-cpp REQUIRED)
find_package(cpr REQUIRED)

# extension lib:
# find_package(odbc REQUIRED)
find_package(SOCI REQUIRED COMPOENTS sock_odbc_static)
# find_package(Qt5 COMPONENTS Core Sql REQUIRED)

# other lib:
find_package(cppzmq REQUIRED)
find_package(RTTR REQUIRED)

target_link_libraries(
  ${PROJECT_NAME}_main PRIVATE

  ${PROJECT_NAME}::Core
  ${PROJECT_NAME}::Sonic

  # require lib:
  # TBB
  # TBB::tbb
  # jsoncpp
  jsoncpp_static
  # range-v3 header only
  # yaml-cpp
  yaml-cpp
  # libcpr
  cpr

  # extension lib:
  # * Qt
  # Qt5::Core
  # Qt5::Sql
  # * POCO
  # * Unix ODBC
  # libodbc # msys2中安装unixodbc，链接libodc库，支持在msys2环境中运行
  # odbc32 # 链接windows自带的odbc库，支持直接使用window odbc配置的数据源
  # * SOCI
  SOCI::soci_core_static
  SOCI::soci_odbc_static
  # Folly

  # other lib:
  # RTTR
  RTTR::Core
  # zeromq
  cppzmq
  # sqlite3
  # openssl
  # ftxui
  # sonic-cpp
)

if(WIN32)
  target_link_libraries(
    ${PROJECT_NAME}_main PRIVATE
    wsock32
  )
endif()