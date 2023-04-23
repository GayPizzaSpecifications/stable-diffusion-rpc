#!/bin/sh
set -e

cd "$(dirname "${0}")/../Common"

exec protoc --swift_opt=Visibility=Public --grpc-swift_opt=Visibility=Public --swift_out=../Sources/StableDiffusionProtos --grpc-swift_out=../Sources/StableDiffusionProtos StableDiffusion.proto
