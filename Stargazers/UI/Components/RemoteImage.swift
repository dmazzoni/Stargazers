//
//  RemoteImage.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 13/12/20.
//

import SwiftUI
import FetchImage

// MARK: - RemoteImage
struct RemoteImage: View {
    
    private var placeholder: Image
    
    @ObservedObject private var image: FetchImage
    
    init(url: URL) {
        self.image = FetchImage(url: url)
        self.placeholder = Image(systemName: "photo")
    }
    
    var body: some View {
        Group {
            if image.isLoading {
                ProgressView()
            } else if let fetchedImage = image.view {
                fetchedImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                placeholder
            }
        }
    }
}

// MARK: - API
extension RemoteImage {
    
    func placeholder(image: Image) -> Self {
        var result = self
        result.placeholder = image
        return result
    }
}

// MARK: - Previews
struct RemoteImage_Previews: PreviewProvider {
    
    static var previews: some View {
        // swiftlint:disable force_unwrapping
        Group {
            RemoteImage(url: URL(string: "https://avatars1.githubusercontent.com/u/583231?s=400&u=a59fef2a493e2b67dd13754231daf220c82ba84d&v=4")!)
            RemoteImage(url: URL(string: "https://localhost")!)
        }
        // swiftlint:enable force_unwrapping
    }
}
