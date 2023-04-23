import CoreImage
import Foundation
import StableDiffusionProtos
import UniformTypeIdentifiers

extension CGImage {
    func toImageData(format: SdImageFormat) throws -> Data {
        guard let data = CFDataCreateMutable(nil, 0) else {
            throw SdCoreError.imageEncodeFailed
        }

        guard let destination = try CGImageDestinationCreateWithData(data, formatToTypeIdentifier(format) as CFString, 1, nil) else {
            throw SdCoreError.imageEncodeFailed
        }

        CGImageDestinationAddImage(destination, self, nil)
        if CGImageDestinationFinalize(destination) {
            return data as Data
        } else {
            throw SdCoreError.imageEncodeFailed
        }
    }

    func toSdImage(format: SdImageFormat) throws -> SdImage {
        let content = try toImageData(format: format)
        var image = SdImage()
        image.format = format
        image.data = content
        return image
    }

    private func formatToTypeIdentifier(_ format: SdImageFormat) throws -> String {
        switch format {
        case .png: return "public.png"
        default: throw SdCoreError.imageEncodeFailed
        }
    }
}

public extension SdImage {
    func toCgImage() throws -> CGImage {
        guard let dataProvider = CGDataProvider(data: data as CFData) else {
            throw SdCoreError.imageDecodeFailed
        }

        if format == .png {
            guard let image = CGImage(pngDataProviderSource: dataProvider, decode: nil, shouldInterpolate: false, intent: .defaultIntent) else {
                throw SdCoreError.imageDecodeFailed
            }
            return image
        } else {
            throw SdCoreError.imageDecodeFailed
        }
    }
}
