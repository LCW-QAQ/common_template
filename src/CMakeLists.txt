aux_source_directory(. SRC_FILES)

add_executable(${PROJECT_NAME}_main ${SRC_FILES})

target_link_directories(${PROJECT_NAME}_main PRIVATE include)
