//
//  ContentView.swift
//  Try_SwiftUI-OnboardingScreen
//
//  Created by Артём on 24.09.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ContentViewViewModel()
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                VStack(spacing: 80) {
                    HStack {
                        progressView
                    }
                    .onAppear {
                        vm.startProgress()
                    }
                    
                    Image(systemName: vm.screenInfo[vm.currentSlide])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    Spacer()
                    
                    VStack {
                        Button {
                            vm.goNext()
                        } label: {
                            Text("Next")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    var progressView: some View {
        ForEach(0...9, id: \.self) { slide in
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule() // серая полоска
                        .fill(.gray)
                        .frame(height: 5)
                    
                    if slide < vm.currentSlide {
                        Capsule() // заполненная полоска
                            .fill(Color.black)
                            .frame(height: 5)
                            .frame(width: geo.size.width)
                    } else if slide == vm.currentSlide {
                        Capsule() // заполняемая полоска
                            .fill(Color.black)
                            .frame(height: 5)
                            .frame(width: geo.size.width * self.vm.progress, alignment: .leading)
                    }
                }
                .onTapGesture {
                    vm.currentSlide = slide
                    vm.startProgress()
                }
            }
        }
    }
}

class ContentViewViewModel: ObservableObject {
    let screenInfo: [String] = [
        "9.circle",
        "8.circle",
        "7.circle",
        "6.circle",
        "5.circle",
        "4.circle",
        "3.circle",
        "2.circle",
        "1.circle",
        "0.circle"
    ]
    
    @Published var currentSlide: Int = 0
    @Published var progress: CGFloat = 0
    @Published var timerTask: DispatchWorkItem?
    
    func startProgress() {
        timerTask?.cancel()
        progress = 0
        withAnimation(.linear(duration: 1)) {
            progress = 1
        }
        
        timerTask = DispatchWorkItem(block: {
            self.goNext()
        })
        
        guard let timerTask else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: timerTask)
    }
    
    func goNext() {
        timerTask?.cancel()
        if currentSlide < screenInfo.count - 1 {
            currentSlide += 1
            startProgress()
        } else {
            currentSlide = 0
            startProgress()
        }
    }
}
