cmake_minimum_required(VERSION 3.10)
project(c_lang C)

set(CMAKE_C_STANDARD 11)

#set output directory
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)

if (NOT DEFINED CXX_SOURCE_DIR)
    set( CXX_SOURCE_DIR ${PROJECT_SOURCE_DIR} )
endif()
# 打印执行的操作系统
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    message(STATUS "Configuring on/for Linux")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    message(STATUS "Configuring on/for macOS")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "Configuring on/for Windows")
elseif(CMAKE_SYSTEM_NAME STREQUAL "AIX")
    message(STATUS "Configuring on/for IBM AIX")
else()
    message(STATUS "Configuring on/for ${CMAKE_SYSTEM_NAME}")
endif()

message(STATUS ${CXX_SOURCE_DIR})

add_executable(c_lang main.c)
