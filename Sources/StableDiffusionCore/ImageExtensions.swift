import CoreImage
import Foundation
import UniformTypeIdentifiers

extension CGImage {
    func toPngData() throws -> Data {
        guard let data = CFDataCreateMutable(nil, 0) else {
            throw SdCoreError.imageEncode
        }

        guard let destination = CGImageDestinationCreateWithData(data, "public.png" as CFString, 1, nil) else {
            throw SdCoreError.imageEncode
        }

        CGImageDestinationAddImage(destination, self, nil)
        if CGImageDestinationFinalize(destination) {
            return data as Data
        } else {
            throw SdCoreError.imageEncode
        }
    }
}
