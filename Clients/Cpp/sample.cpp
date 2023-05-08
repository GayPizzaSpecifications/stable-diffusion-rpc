#include "host.grpc.pb.h"
#include "image_generation.grpc.pb.h"

#include <grpc++/grpc++.h>

using namespace gay::pizza::stable::diffusion;

int CompareModelInfoByLoadedFirst(ModelInfo& left, ModelInfo& right) {
    if (left.is_loaded() && right.is_loaded()) {
        return 0;
    }

    if (left.is_loaded()) {
        return 1;
    }

    if (right.is_loaded()) {
        return -1;
    }
    return 0;
}

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

    std::sort(models.begin(), models.end(), CompareModelInfoByLoadedFirst);
    auto model = models.begin();
    std::cout << "Chosen Model: " << model->name() << std::endl;
    return 0;
}
