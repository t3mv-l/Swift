//
//  PhotoEditorView.swift
//  PhotoEditor
//
//  Created by Артём on 30.04.2025.
//

import SwiftUI

struct PhotoEditorView: View {
    @StateObject private var viewModel = PhotoEditorViewViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
//                Image(systemName: "photo")
//                    .resizable()
//                    .frame(width: 80, height: 80)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                    ForEach(viewModel.photos, id: \.self) { asset in
                        NavigationLink(destination: FullImageView(asset: asset)) {
                            ImageView(asset: asset)
                                .frame(width: 100, height: 100)
                                .clipped()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
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
                    Button {
                        viewModel.loadPhotos()
                    } label: {
                        Text("Add photo")
                            .bold()
                            .padding(10)
                    }
                }
            }
        }
    }
}

#Preview {
    PhotoEditorView()
}
