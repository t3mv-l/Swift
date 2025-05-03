//
//  ImageView.swift
//  PhotoEditor
//
//  Created by Артём on 01.05.2025.
//

import Photos
import SwiftUI

struct ImageView: View {
    let asset: PHAsset
    
    var body: some View {
        Image(uiImage: loadImage())
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
    
    private func loadImage() -> UIImage {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        var uiImage: UIImage?
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options) { image, _ in
            uiImage = image
        }
        
        return uiImage ?? UIImage()
    }
}

