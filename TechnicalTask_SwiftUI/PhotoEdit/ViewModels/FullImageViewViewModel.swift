//
//  FullImageViewViewModel.swift
//  PhotoEdit
//
//  Created by Артём on 04.05.2025.
//

import Photos
import SwiftUI

class FullImageViewViewModel: ObservableObject {
    @Published var rotation: Double = 0.0
    var asset: PHAsset?
    
    init(asset: PHAsset?) {
        self.asset = asset
    }
    
    func loadImage() -> UIImage {
        guard let asset = asset else { return UIImage() }
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
            
        var uiImage: UIImage?
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { image, _ in
            uiImage = image
        }
            
        return uiImage ?? UIImage()
    }
    
    func rotateClockwise() {
        rotation += 90.0
    }
    
    func rotateCounterClockwise() {
        rotation -= 90.0
    }
}
