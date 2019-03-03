# CMake minimum version
cmake_minimum_required(VERSION 2.4)

if(COMMAND cmake_policy)
    cmake_policy(SET CMP0048 NEW)
endif(COMMAND cmake_policy)

# project name and language
project(zbar LANGUAGES C VERSION 2.0.2)

subdirs(zbar)
