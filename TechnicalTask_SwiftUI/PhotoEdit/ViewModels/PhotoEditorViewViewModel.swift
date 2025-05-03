//
//  PhotoEditorViewViewModel.swift
//  PhotoEditor
//
//  Created by Артём on 01.05.2025.
//

import FirebaseAuth
import SwiftUI
import Photos
import GoogleSignIn

class PhotoEditorViewViewModel: ObservableObject {
    @Published var photos: [PHAsset] = []
    private let manager = PhotoManager()
    @Published var isLoading: Bool = false
    
    func loadPhotos() {
        manager.requestPhotoLibraryAccess { [weak self] granted in
            guard granted else { return }
            DispatchQueue.main.async {
                self?.photos = self?.manager.fetchPhotos() ?? []
            }
        }
    }
    
    func logout() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            do {
                GIDSignIn.sharedInstance.signOut()
                try Auth.auth().signOut()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            self?.isLoading = false
        }
    }
}
