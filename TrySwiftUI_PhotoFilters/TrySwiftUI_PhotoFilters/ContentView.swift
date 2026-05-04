//
//  ContentView.swift
//  TrySwiftUI_PhotoFilters
//
//  Created by Артём on 16.04.2026.
//

import SwiftUI
import Combine

enum Georgia: String {
    case regular = "Georgia"
    case bold = "Georgia-Bold"
    case italic = "Georgia-Italic"
    case boldItalic = "Georgia-BoldItalic"
}

extension Text {
    func fontGeorgia(_ font: Georgia, _ size: CGFloat = 16) -> some View {
        self.font(.custom(font.rawValue, size: size))
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            picker.dismiss(animated: true)
        }
    }
}

class ContentViewModel: NSObject, ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var filteredImage: UIImage?
    @Published var isShowCamera: Bool = false
    @Published var selectedFilter: NStyle = .original
    
    @Published var showSaveAlert = false
    @Published var saveAlertMessage = ""
    
    @Published var thumbnails: [NStyle: UIImage] = [:]
    
    func processNewImage() {
        filteredImage = nil
        thumbnails = [:]
        
        guard let selectedImage else { return }
        
        if selectedFilter == .original {
            filteredImage = selectedImage
        }
        
        Task {
            await generateThumbnails(for: selectedImage)
            applyFilter(selectedFilter)
        }
    }
    
    func applyFilter(_ filter: NStyle) {
        guard let selectedImage else { return }
        selectedFilter = filter
        
        if filter == .original {
            self.filteredImage = selectedImage
            return
        }
        
        Task {
            let result = await processImage(selectedImage, with: filter)
            await MainActor.run {
                self.filteredImage = result
            }
        }
    }
    
    func savePhoto() {
        guard let image = filteredImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            if let error = error {
                self.saveAlertMessage = "Ошибка сохранения: \(error.localizedDescription)"
            } else {
                self.saveAlertMessage = "Фотография успешно сохранена в галерею"
            }
            self.showSaveAlert = true
        }
    }
        
    func reset() {
        selectedImage = nil
        filteredImage = nil
        thumbnails = [:]
    }
    
    private func generateThumbnails(for image: UIImage) async {
        guard let thumbnail = image.resized(to: CGSize(width: 200, height: 200)) else { return }
        var newThumbnails: [NStyle: UIImage] = [:]
        
        for filter in NStyle.allCases {
            if filter == .original {
                newThumbnails[filter] = thumbnail
            } else if let filtered = await processImage(thumbnail, with: filter) {
                newThumbnails[filter] = filtered
            }
        }
        
        await MainActor.run {
            self.thumbnails = newThumbnails
        }
    }
    
    private func processImage(_ image: UIImage, with filter: NStyle) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let result = filter.applyImage(image)
                continuation.resume(returning: result)
            }
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Rectangle()
                .fill(.white.opacity(0.05))
                .ignoresSafeArea()
            
            if vm.selectedImage == nil {
                landingView
            } else {
                editView
            }
        }
        .alert("Сохранение", isPresented: $vm.showSaveAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(vm.saveAlertMessage)
        }
        .onChange(of: vm.selectedImage) {
            vm.processNewImage()
        }
    }
}

extension ContentView {
    var landingView: some View {
        VStack {
            Spacer()
            VStack(spacing: 13) {
                HStack(spacing: 13) {
                    Text("TOP")
                        .fontGeorgia(.boldItalic, 48)
                        .foregroundStyle(.white)
                    Text("PHOTO")
                        .fontGeorgia(.boldItalic, 48)
                        .foregroundStyle(.gray)
                }
                Divider()
                    .background(.gray)
                    .frame(width: 250)
                Text("Обработка фотографий")
                    .fontGeorgia(.regular, 14)
                    .foregroundStyle(.gray)
                    .textCase(.uppercase)
                    .kerning(3)
            }
            Spacer()
            Button {
                vm.isShowCamera = true
            } label: {
                HStack(spacing: 19) {
                    Image(systemName: "camera.fill")
                    Text("Выбрать фото")
                        .fontGeorgia(.bold, 14)
                        .textCase(.uppercase)
                        .kerning(3)
                }
                .padding(20)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .sheet(isPresented: $vm.isShowCamera) {
                ImagePicker(selectedImage: $vm.selectedImage)
            }

        }
        .padding(.horizontal, 30)
        .padding(.bottom, 50)
    }
}

extension ContentView {
    var editView: some View {
        VStack {
            HStack {
                Button {
                    vm.reset()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                }
                Spacer()
                Text("TOP PHOTO")
                    .fontGeorgia(.boldItalic, 30)
                    .textCase(.uppercase)
                    .foregroundStyle(.white)
                    .kerning(3)
                Spacer()
                Button {
                    vm.savePhoto()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                }

            }
            Spacer()
                //.frame(maxHeight: 80)
            ZStack {
                if let image = vm.filteredImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                } else if let image = vm.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                        }
                }
            }
            .padding(.horizontal, 30)
            Spacer()
                //.frame(maxHeight: 80)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(NStyle.allCases) { filter in
                        FilterThumb(
                            filter: filter,
                            thumbnail: vm.thumbnails[filter],
                            isSelected: vm.selectedFilter == filter
                        ) {
                            vm.applyFilter(filter)
                        }
                    }
                }
            }
        }
    }
}

struct FilterThumb: View {
    let filter: NStyle
    let thumbnail: UIImage?
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 6) {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let image = thumbnail {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Color.gray.opacity(0.3)
                                .overlay(
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                )
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(isSelected ? .white : .clear, lineWidth: 2)
                    }
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 16))
                            .padding(6)
                    }
                }
                Text(filter.rawValue)
                    .fontGeorgia(.italic, 14)
                    .foregroundStyle(.white)
            }
        }
    }
}

enum NStyle: String, Identifiable, CaseIterable {
    var id: String { UUID().uuidString }
    case original = "Оригинал"
    case noir = "Нуар"
    case mono = "Моно"
    case tonal = "Мягкий"
    case process = "Процесс"
    case chrome = "Хром"
    case transfer = "Трансфер"
    case sepia = "Сепия"
    
    func applyImage(_ image: UIImage) -> UIImage? {
        if self == .original {
            return image
        }
        
        guard let ciImage = CIImage(image: image) else { return nil }
        let filterName: String
        
        switch self {
        case .original:
            return image
        case .noir:
            filterName = "CIPhotoEffectNoir"
        case .mono:
            filterName = "CIPhotoEffectMono"
        case .tonal:
            filterName = "CIPhotoEffectTonal"
        case .process:
            filterName = "CIPhotoEffectProcess"
        case .chrome:
            filterName = "CIPhotoEffectChrome"
        case .transfer:
            filterName = "CIPhotoEffectTransfer"
        case .sepia:
            filterName = "CISepiaTone"
        }
        
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        let context = CIContext()
        guard let output = filter?.outputImage, let cgImage = context.createCGImage(output, from: output.extent) else { return nil}
        
        return UIImage(cgImage: cgImage, scale: 1, orientation: image.imageOrientation)
    }
}

#Preview {
    ContentView()
}
