//
//  PhotoEditorView.swift
//  PhotoEditor
//
//  Created by Артём on 30.04.2025.
//

import SwiftUI
import PhotosUI

struct PhotoEditorView: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    @StateObject private var viewModel = PhotoEditorViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = viewModel.selectedImage {
                    FullImageView(image: image, viewModel: viewModel)
                        .rotationEffect(.degrees(viewModel.rotation))
                        .scaleEffect(scale)
                        .gesture(magnificationGesture)
                }
            }
            .padding()
            .navigationTitle("Photo Editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.logout()
                    } label: {
                        Text("Sign Out")
                            .bold()
                            .padding(10)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    PhotosPicker("+", selection: $viewModel.imageSelection, matching: .images)
                        .font(.title2)
                        .bold()
                        .padding(10)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            viewModel.rotateCounterClockwise()
                        } label: {
                            HStack {
                                Text("Rotate counterclockwise")
                                Image(systemName: "gobackward")
                            }
                        }
                        
                        Button {
                            viewModel.rotateClockwise()
                        } label: {
                            HStack {
                                Text("Rotate clockwise")
                                Image(systemName: "goforward")
                            }
                        }
                        
                        Button {
                            viewModel.saveDrawing()
                        } label: {
                            HStack {
                                Text("Save photo")
                                Image(systemName: "square.and.arrow.down")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Saved to Photos"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = lastScale * value
            }
            .onEnded { value in
                lastScale = scale
            }
    }
}

#Preview {
    PhotoEditorView()
}
