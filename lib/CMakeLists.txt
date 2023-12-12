# Enlist source from current directory recursively
file(GLOB_RECURSE sources *.c *.cc *.cpp *.cxx)

# DO NOT EDIT THE BELOW!

# Declare project for this scope
project(lib${ROOT_PROJECT_NAME})

# Add target library to build with source
add_library(${PROJECT_NAME} OBJECT ${sources})

# Add directory for including headers
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/include)

# Add target library to build with source
add_library(${PROJECT_NAME}.a STATIC)
target_link_libraries(${PROJECT_NAME}.a PRIVATE ${PROJECT_NAME})
add_library(${PROJECT_NAME}.so SHARED)
target_link_libraries(${PROJECT_NAME}.so PRIVATE ${PROJECT_NAME})

# Add build options
target_compile_options(${PROJECT_NAME} PUBLIC $<$<COMPILE_LANGUAGE:C>:-fpic>)
target_compile_options(${PROJECT_NAME} PUBLIC $<$<COMPILE_LANGUAGE:CXX>:-fpic>)

# Enforce output name format
set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "" OUTPUT_NAME
                                                           ${PROJECT_NAME})
set_target_properties(${PROJECT_NAME}.a PROPERTIES PREFIX "" OUTPUT_NAME
                                                             ${PROJECT_NAME})
set_target_properties(${PROJECT_NAME}.so PROPERTIES PREFIX "" OUTPUT_NAME
                                                              ${PROJECT_NAME})

# Set custom directory for "install"
install(TARGETS ${PROJECT_NAME}.a LIBRARY)
install(TARGETS ${PROJECT_NAME}.so LIBRARY)
