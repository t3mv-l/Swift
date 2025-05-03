//
//  PhotoManager.swift
//  PhotoEditor
//
//  Created by Артём on 01.05.2025.
//

import Photos

class PhotoManager {
    
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                completion(true)
            case .denied, .restricted, .notDetermined:
                completion(false)
            case .limited:
                completion(false)
            @unknown default:
                completion(false)
            }
        }
    }
    
    func fetchPhotos() -> [PHAsset] {
        var photos: [PHAsset] = []
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        fetchResult.enumerateObjects { asset, _, _ in
            photos.append(asset)
        }
        
        return photos
    }
}
