//
//  PhotoEditorViewViewModel.swift
//  PhotoEditor
//
//  Created by Артём on 01.05.2025.
//

import FirebaseAuth
import SwiftUI
import PencilKit
import PhotosUI
import GoogleSignIn

class PhotoEditorViewViewModel: ObservableObject {
    @Published var rotation: Double = 0.0
    @Published var selectedImage: UIImage?
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            loadSelectedImage()
        }
    }
    @Published var canvasDrawing = PKDrawing()
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
        
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
    
    private func loadSelectedImage() {
        guard let imageSelection = imageSelection else { return }
            
        Task {
            if let data = try? await imageSelection.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                await MainActor.run {
                    self.selectedImage = image
                }
            }
        }
    }
    
    func rotateClockwise() {
        rotation += 90.0
    }
        
    func rotateCounterClockwise() {
        rotation -= 90.0
    }
        
    func saveDrawing() {
        guard let image = selectedImage else { return }
            
        let renderer = UIGraphicsImageRenderer(size: image.size)
        let finalImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
                
            //let drawingImage = canvasDrawing.image(from: CGRect(origin: .zero, size: image.size), scale: UIScreen.main.scale)
                
            let canvasSize = canvasDrawing.bounds.size
            let scale = min(image.size.width / canvasSize.width, image.size.height / canvasSize.height)
                
            let transform = CGAffineTransform(scaleX: scale, y: scale)
                
            let drawingImage = canvasDrawing.image(from: canvasDrawing.bounds, scale: UIScreen.main.scale)
                
            //drawingImage.draw(in: CGRect(origin: .zero, size: image.size))
                
            context.cgContext.concatenate(transform)
            drawingImage.draw(in: canvasDrawing.bounds)
        }
            
        UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            
        showAlert = true
    }
        
    func clearDrawing() {
        canvasDrawing = PKDrawing()
    }    
}
