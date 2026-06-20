//
//  ImageDownsampler.swift
//  ImagePicker
//
//  Created by Wesley de Groot on 2026-06-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/ImagePicker
//  MIT License
//

import CoreGraphics
import Foundation
import ImageIO

/// Downsamples encoded image data without decoding the full-resolution image.
enum ImageDownsampler {
    /// Creates an image whose longest edge does not exceed the requested pixel dimension.
    static func image(from data: Data, maximumPixelDimension: Int) async -> CGImage? {
        await Task.detached(priority: .userInitiated) {
            guard !Task.isCancelled else {
                return nil
            }

            let sourceOptions = [
                kCGImageSourceShouldCache: false
            ] as CFDictionary

            guard let source = CGImageSourceCreateWithData(data as CFData, sourceOptions) else {
                return nil
            }

            let thumbnailOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceThumbnailMaxPixelSize: max(1, maximumPixelDimension)
            ] as CFDictionary

            return CGImageSourceCreateThumbnailAtIndex(source, 0, thumbnailOptions)
        }.value
    }
}
