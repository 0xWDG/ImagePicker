# ImagePicker

ImagePicker is a Swift Package to make it easy to pick images from the photo library.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FImagePicker%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0xWDG/ImagePicker)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FImagePicker%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0xWDG/ImagePicker)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
![License](https://img.shields.io/github/license/0xWDG/ImagePicker)

## Requirements

- Swift 5.9+ (Xcode 15+)
- iOS 13+, macOS 10.15+

## Installation (Pakage.swift)

```swift
dependencies: [
    .package(url: "https://github.com/0xWDG/ImagePicker.git", branch: "main"),
],
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "ImagePicker", package: "ImagePicker"),
    ]),
]
```

## Installation (Xcode)

1. In Xcode, open your project and navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Paste the repository URL (`https://github.com/0xWDG/ImagePicker`) and click **Next**.
3. Click **Finish**.

## Usage

```swift
import SwiftUI
import ImagePicker

struct ContentView: View {
    @State
    private var image: Image?

    var body: some View {
        VStack {
            ImagePicker(image: $image)
                .frame(width: 150, height: 150)
        }
        .padding()
    }
}
```

## Contact

🦋 [@0xWDG](https://bsky.app/profile/0xWDG.bsky.social)
🐘 [mastodon.social/@0xWDG](https://mastodon.social/@0xWDG)
🐦 [@0xWDG](https://x.com/0xWDG)
🧵 [@0xWDG](https://www.threads.net/@0xWDG)
🌐 [wesleydegroot.nl](https://wesleydegroot.nl)
🤖 [Discord](https://discordapp.com/users/918438083861573692)

Interested learning more about Swift? [Check out my blog](https://wesleydegroot.nl/blog/).
