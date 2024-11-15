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

/// ImagePicker
///
/// A SwiftUI Image Picker
///
/// Example:
/// ```swift
/// @State var photo: Image?
///
/// var body: some View {
///     ImagePicker(photo: $photo)
/// }
/// ```
public struct ImagePicker: View {
    /// The selected image
    @Binding
    var image: Image?

    /// Is the PhotosPicker presented?
    @State
    private var photosPickerIsPresented = false

    /// The selected picker items
    @State
    private var selectedPickerItem: [PhotosPickerItem] = []

    /// The decoded images
    @State
    private var images: [Image?] = []

    /// The maximum selection count
    var maxSelectionCount: Int = 1

    /// Initialize the ImagePicker
    ///
    /// - Parameters:
    ///   - photo: The selected image
    public init(photo: Binding<Image?>) {
        self._image = photo
    }

    /// The body of the ImagePicker
    public var body: some View {
        ZStack {
            if image == nil {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.secondary.opacity(0.8))
                    .accessibilityHidden(true)
            } else {
                image?
                    .resizable()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "photo.badge.plus")
                        .accessibilityHidden(true)
                        .padding(7)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(.black, width: 1)
        .onTapGesture {
            photosPickerIsPresented.toggle()
        }
        .photosPicker(
            isPresented: $photosPickerIsPresented,
            selection: $selectedPickerItem,
            maxSelectionCount: maxSelectionCount
        )
        .onChange(of: $selectedPickerItem.wrappedValue, perform: { _ in
            Task {
#if canImport(UIKit)
                if let imageData = try? await selectedPickerItem.first?.loadTransferable(
                    type: Data.self
                ), let decodedImage = UIImage(data: imageData) {
                    image = Image(uiImage: decodedImage)
                }
#elseif canImport(AppKit)
                if let imageData = try? await selectedPickerItem.first?.loadTransferable(
                    type: Data.self
                ), let decodedImage = NSImage(data: imageData) {
                    image = Image(nsImage: decodedImage)
                }
#endif
            }
        })
        .accessibilityLabel("Image picker")
        .accessibilityHint("Tap to select a image")
        .accessibilityAddTraits(.isButton)
    }
}

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
                    ImagePicker(photo: $photo)
                        .frame(width: 150, height: 150)
                }

                VStack {
                    ImagePicker(photo: $photo)
                        .frame(width: 150, height: 150)
                }
                .background(.red)
            }

            HStack {
                VStack {
                    ImagePicker(photo: $photo)
                        .frame(width: 150, height: 150)
                }
                .background(.blue)

                VStack {
                    ImagePicker(photo: $photo)
                        .frame(width: 150, height: 150)
                }
                .background(.green)
            }
        }
    }
}

#endif
