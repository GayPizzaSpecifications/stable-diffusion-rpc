cmake_minimum_required(VERSION 3.20)
project(sdrpc)

find_package(Protobuf CONFIG REQUIRED)
find_package(gRPC CONFIG REQUIRED)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

add_library(sdrpc StableDiffusion.proto)

get_target_property(grpc_cpp_plugin_location gRPC::grpc_cpp_plugin LOCATION)

protobuf_generate(TARGET sdrpc LANGUAGE cpp)
protobuf_generate(TARGET sdrpc LANGUAGE grpc
        GENERATE_EXTENSIONS .grpc.pb.h .grpc.pb.cc
        PLUGIN "protoc-gen-grpc=${grpc_cpp_plugin_location}")
target_include_directories(sdrpc PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(sdrpc PUBLIC protobuf::libprotobuf gRPC::grpc gRPC::grpc++)

add_executable(sdrpc_sample sample.cpp)
target_include_directories(sdrpc_sample PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(sdrpc_sample PRIVATE sdrpc)
