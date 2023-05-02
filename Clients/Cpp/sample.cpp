#include "StableDiffusion.pb.h"
#include "StableDiffusion.grpc.pb.h"

#include <grpc++/grpc++.h>

using namespace gay::pizza::stable::diffusion;

int main() {
    auto channel = grpc::CreateChannel("localhost:4546", grpc::InsecureChannelCredentials());
    auto modelService = ModelService::NewStub(channel);
    auto imageGenerationService = ImageGenerationService::NewStub(channel);

    grpc::ClientContext context;

    ListModelsRequest listModelsRequest;
    ListModelsResponse response;
    modelService->ListModels(&context, listModelsRequest, &response);
    auto models = response.available_models();
    for (const auto &item: models) {
        std::cout << "Model Name: " << item.name() << std::endl;
    }
    return 0;
}
