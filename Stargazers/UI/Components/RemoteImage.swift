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
    
    @ObservedObject private var image: FetchImage
    
    init(url: URL) {
        self.image = FetchImage(url: url)
    }
    
    var body: some View {
        Group {
            if image.isLoading {
                ProgressView()
            } else {
                image.view?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
