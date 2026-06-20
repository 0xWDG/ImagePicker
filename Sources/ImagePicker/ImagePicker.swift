//
//  ImagePicker.swift
//  ImagePicker
//
//  Created by Wesley de Groot on 2024-11-15.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/ImagePicker
//  MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import PhotosUI

/// A SwiftUI control that selects and displays an image from the photo library.
///
/// Example:
/// ```swift
/// @State private var image: Image?
///
/// var body: some View {
///     ImagePicker(image: $image)
/// }
/// ```
@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
public struct ImagePicker: View {
    /// The selected image
    @Binding
    private var image: Image?

    /// Is the PhotosPicker presented?
    @State
    private var photosPickerIsPresented = false

    /// The selected picker item
    @State
    private var selectedPickerItem: PhotosPickerItem?

    /// The longest edge of the decoded image, in pixels
    private let maximumPixelDimension: Int

    /// Initialize the ImagePicker
    ///
    /// - Parameter image: The selected image.
    /// - Parameter maximumPixelDimension: The longest edge of the decoded image, in pixels.
    public init(image: Binding<Image?>, maximumPixelDimension: Int = 2_048) {
        self._image = image
        self.maximumPixelDimension = max(1, maximumPixelDimension)
    }

    /// Initialize the ImagePicker.
    ///
    /// - Parameter photo: The selected image.
    /// - Parameter maximumPixelDimension: The longest edge of the decoded image, in pixels.
    @available(*, deprecated, renamed: "init(image:maximumPixelDimension:)")
    public init(photo: Binding<Image?>, maximumPixelDimension: Int = 2_048) {
        self.init(image: photo, maximumPixelDimension: maximumPixelDimension)
    }

    /// The body of the ImagePicker
    public var body: some View {
        Button {
            photosPickerIsPresented = true
        } label: {
            ZStack(alignment: .bottomTrailing) {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                        .padding()
                }

                Image(systemName: "photo.badge.plus")
                    .padding(7)
                    .foregroundStyle(.tint)
            }
            .accessibilityHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .overlay {
            Rectangle()
                .stroke(.secondary, lineWidth: 1)
                .allowsHitTesting(false)
        }
        .photosPicker(
            isPresented: $photosPickerIsPresented,
            selection: $selectedPickerItem,
            matching: .images
        )
        .task(id: selectedPickerItem) {
            await loadSelectedImage()
        }
        .accessibilityLabel("Image picker")
        .accessibilityHint("Select an image from the photo library")
    }

    /// Loads the current selection and ignores stale work after cancellation.
    @MainActor
    private func loadSelectedImage() async {
        guard let selectedPickerItem else {
            return
        }

        defer {
            if self.selectedPickerItem == selectedPickerItem {
                self.selectedPickerItem = nil
            }
        }

        guard
            let imageData = try? await selectedPickerItem.loadTransferable(type: Data.self),
            !Task.isCancelled,
            let decodedImage = await ImageDownsampler.image(
                from: imageData,
                maximumPixelDimension: maximumPixelDimension
            ),
            !Task.isCancelled
        else {
            return
        }

        image = Image(decorative: decodedImage, scale: 1)
    }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
struct ImagePicker_Previews: PreviewProvider {
    @State
    static var photo: Image?

    static var previews: some View {
        VStack {
            Button("Reset") {
                photo = nil
            }

            HStack(alignment: .center) {
                VStack {
                    ImagePicker(image: $photo)
                        .frame(width: 150, height: 150)
                }

                VStack {
                    ImagePicker(image: $photo)
                        .frame(width: 150, height: 150)
                }
                .background(.red.opacity(0.5))
            }

            HStack {
                VStack {
                    ImagePicker(image: $photo)
                        .frame(width: 150, height: 250)
                }
                .background(.blue.opacity(0.5))

                VStack {
                    ImagePicker(image: $photo)
                        .frame(width: 150, height: 250)
                }
                .background(.green.opacity(0.5))
            }

            HStack {
                VStack {
                    ImagePicker(image: $photo)
                        .frame(width: 175, height: 100)
                }
                .background(.orange.opacity(0.5))

                VStack {
                    ImagePicker(image: $photo)
                        .frame(width: 175, height: 100)
                }
                .background(.purple.opacity(0.5))
            }
        }
    }
}
#endif
