# CMake minimum version
cmake_minimum_required(VERSION 2.4)

if(COMMAND cmake_policy)
    cmake_policy(SET CMP0048 NEW)
endif(COMMAND cmake_policy)

# project name and languages
project(zbar LANGUAGES C VERSION 2.0.2)

# version info
set(PACKAGE_VERSION 0.10)
set(ZBAR_VERSION_MAJOR 0)
set(ZBAR_VERSION_MINOR 10)
set(LIB_VERSION_MAJOR 2)
set(LIB_VERSION_MINOR 0)
set(LIB_VERSION_REVISION 2)

subdirs(zbar)
