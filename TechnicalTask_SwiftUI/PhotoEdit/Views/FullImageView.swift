//
//  FullImageView.swift
//  PhotoEditor
//
//  Created by Артём on 01.05.2025.
//

//import CoreImage
import PencilKit
import PhotosUI
import SwiftUI

struct FullImageView: UIViewRepresentable {
    let image: UIImage
    @ObservedObject var viewModel: PhotoEditorViewViewModel
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
        canvasView.delegate = context.coordinator
        canvasView.drawing = viewModel.canvasDrawing
        
        let imageSize = image.size
        let viewSize = canvasView.bounds.size
        let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
        let scaledSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        
        let xOffset = (viewSize.width - scaledSize.width)
        let yOffset = (viewSize.height - scaledSize.height)
        canvasView.contentSize = scaledSize
        canvasView.contentOffset = CGPoint(x: -xOffset, y: -yOffset)
        
        context.coordinator.drawingBounds = CGRect(origin: .zero, size: scaledSize)
        
        let toolPicker = PKToolPicker()
        toolPicker.addObserver(canvasView)
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        canvasView.becomeFirstResponder()
        
        context.coordinator.toolPicker = toolPicker
        
        if let toolPicker = context.coordinator.toolPicker {
            toolPicker.addObserver(canvasView)
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            canvasView.becomeFirstResponder()
        }
        
        let backgroundImageView = UIImageView(image: image)
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.frame = canvasView.bounds
        canvasView.insertSubview(backgroundImageView, at: 0)
        
        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        if let backgroundImageView = canvasView.subviews.first as? UIImageView {
            backgroundImageView.image = image
            backgroundImageView.frame = canvasView.bounds
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: FullImageView
        var toolPicker: PKToolPicker?
        var drawingBounds: CGRect?
        
        init(_ parent: FullImageView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            Task { @MainActor in
                parent.viewModel.canvasDrawing = canvasView.drawing
            }
        }
    }
}


//struct FullImageView: View {
//    @StateObject private var viewModel: FullImageViewViewModel
//    
//    @State private var scale: CGFloat = 1.0
//    @State private var lastScale: CGFloat = 1.0
////    @State private var canvasView = PKCanvasView()
////    @State private var toolPicker = PKToolPicker()
//    
//    var body: some View {
//        VStack {
//            Image(uiImage: viewModel.loadImage())
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .rotationEffect(.degrees(viewModel.rotation))
//                .scaleEffect(scale)
//                .padding()
//                .gesture(
//                    MagnificationGesture()
//                        .onChanged { value in
//                            scale = lastScale * value
//                        }
//                        .onEnded { value in
//                            lastScale = scale
//                        }
//                )
//        }
//        .toolbar {
//            ToolbarItem(placement: .automatic) {
//                Button {
//                    viewModel.rotateCounterClockwise()
//                } label: {
//                    Image(systemName: "gobackward")
//                }
//            }
//            ToolbarItem(placement: .topBarTrailing) {
//                Button {
//                    viewModel.rotateClockwise()
//                } label: {
//                    Image(systemName: "goforward")
//                }
//            }
//        }
//    }
//}

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
