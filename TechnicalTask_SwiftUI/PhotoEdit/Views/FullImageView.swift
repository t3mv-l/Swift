//
//  FullImageView.swift
//  PhotoEditor
//
//  Created by Артём on 01.05.2025.
//

//import CoreImage
import PencilKit
import Photos
import SwiftUI

struct FullImageView: View {
    @State private var rotation: Double = 0.0
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
//    @State private var canvasView = PKCanvasView()
//    @State private var toolPicker = PKToolPicker()
    
    let asset: PHAsset

    var body: some View {
        VStack {
            Image(uiImage: loadImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(rotation))
                .scaleEffect(scale)
                .padding()
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = lastScale * value
                        }
                        .onEnded { value in
                            lastScale = scale
                        }
                )
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    rotateCounterClockwise()
                } label: {
                    Image(systemName: "gobackward")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    rotateClockwise()
                } label: {
                    Image(systemName: "goforward")
                }
            }
        }
    }

    private func loadImage() -> UIImage {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
            
        var uiImage: UIImage?
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { image, _ in
            uiImage = image
        }
            
        return uiImage ?? UIImage()
    }
    
    private func rotateClockwise() {
        rotation += 90.0
    }
    
    private func rotateCounterClockwise() {
        rotation -= 90.0
    }
}

//struct CanvasView: UIViewRepresentable {
//    @Binding var canvasView: PKCanvasView
//    
//    func makeUIView(context: Context) -> PKCanvasView {
//        canvasView.drawingPolicy = .anyInput
//        return canvasView
//    }
//    
//    func updateUIView(_ uiView: PKCanvasView, context: Context) {
//        
//    }
//}
//
//struct ContentView: View {
//    @State private var canvasView = PKCanvasView()
//    @State private var toolPicker = PKToolPicker()
//    
//    var body: some View {
//        VStack {
//            CanvasView(canvasView: $canvasView)
//                .onAppear {
//                    if let window = UIApplication.shared.windows.first {
//                        toolPicker.setVisible(true, forFirstResponder: canvasView)
//                        toolPicker.addObserver(canvasView)
//                        canvasView.becomeFirstResponder()
//                    }
//                }
//                .background(Color.white)
//                .cornerRadius(10)
//                .shadow(radius: 5)
//                .padding()
//        }
//        .padding()
//    }
//}
