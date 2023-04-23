#include <StableDiffusion.pb.h>
#include <iostream>

using namespace gay::pizza::stable::diffusion;

int main() {
    ModelInfo info;
    info.set_name("anything-4.5");
    std::cout << info.DebugString() << std::endl;
    return 0;
}
