//
//  ImagePickerTests.swift
//  ImagePicker
//
//  Created by Wesley de Groot on 2024-11-15.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/ImagePicker
//  MIT License
//

import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
import XCTest

@testable import ImagePicker

/// Tests for image decoding behavior.
final class ImageDownsamplerTests: XCTestCase {
    /// Verifies that large images are decoded at the requested size.
    func testImageIsDownsampledWhilePreservingAspectRatio() async throws {
        let sourceImage = try makeImage(width: 400, height: 200)
        let imageData = try makePNGData(from: sourceImage)

        let downsampledImage = await ImageDownsampler.image(
            from: imageData,
            maximumPixelDimension: 100
        )
        let image = try XCTUnwrap(downsampledImage)

        XCTAssertEqual(image.width, 100)
        XCTAssertEqual(image.height, 50)
    }

    /// Creates an in-memory image for testing.
    private func makeImage(width: Int, height: Int) throws -> CGImage {
        let context = try XCTUnwrap(
            CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: 0,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )
        )

        return try XCTUnwrap(context.makeImage())
    }

    /// Encodes an image as PNG data.
    private func makePNGData(from image: CGImage) throws -> Data {
        let data = NSMutableData()
        let destination = try XCTUnwrap(
            CGImageDestinationCreateWithData(
                data,
                UTType.png.identifier as CFString,
                1,
                nil
            )
        )

        CGImageDestinationAddImage(destination, image, nil)
        XCTAssertTrue(CGImageDestinationFinalize(destination))
        return data as Data
    }
}
