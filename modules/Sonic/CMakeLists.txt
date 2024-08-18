add_library(Sonic INTERFACE)
add_library(${PROJECT_NAME}::Sonic ALIAS Sonic)

CMKMOD_INSTALL(Sonic)
CMKMOD_GENERATE_PACKAGE(Sonic)