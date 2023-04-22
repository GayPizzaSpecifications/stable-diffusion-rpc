import Foundation
import CoreImage
import UniformTypeIdentifiers

extension CGImage {
    func toPngData() throws -> Data {
        guard let data = CFDataCreateMutable(nil, 0) else {
            throw SdServerError.imageEncode
        }
        
        guard let destination = CGImageDestinationCreateWithData(data, "public.png" as CFString, 1, nil) else {
            throw SdServerError.imageEncode
        }
        
        CGImageDestinationAddImage(destination, self, nil)
        if CGImageDestinationFinalize(destination) {
            return data as Data
        } else {
            throw SdServerError.imageEncode
        }
    }
}
