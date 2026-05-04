//
//  ContentView.swift
//  TrySwiftUI_FaceID
//
//  Created by Артём on 10.04.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ContentViewModel()
    
    var body: some View {
        ZStack {
            Color(hex: "1F1F1F")
                .ignoresSafeArea()
            
            GeometryReader { geo in
                Circle()
                    .fill(Color(hex: "7C3AED").opacity(0.3))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .offset(x: -60, y: -100)
                
                Circle()
                    .fill(Color(hex: "2563EB").opacity(0.2))
                    .frame(width: 250, height: 250)
                    .blur(radius: 80)
                    .offset(x: geo.size.width - 160, y: geo.size.height - 300)
            }
            .ignoresSafeArea()
            
            if vm.isUnlocked {
                SuccessView()
            } else {
                mainContent
            }
        }
    }
}

extension ContentView {
    var mainContent: some View {
        VStack(spacing: 0) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 72, height: 72)
                
                Image(systemName: lockIcon)
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 30)
            
            VStack(spacing: 5) {
                Text(vm.headerTitle)
                    .foregroundStyle(.white)
                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                
                Text(vm.headerSubtitle)
                    .foregroundStyle(.white.opacity(0.5))
                    .font(.system(size: 15, weight: .regular, design: .rounded))
            }
            .padding(.bottom, 30)
            
            PasscodeDots(count: 4, filledCount: vm.digits.count, success: vm.showSuccess)
                .padding(.bottom, 15)
            
            Text(vm.errorMessage)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.red)
                .padding(.bottom, 35)
            
            KeyPad(
                onDigit: { vm.appendDigit($0) },
                onDelete: { vm.deleteLastDigit() },
                onFaceID: vm.mode == .unlock ? { vm.authWithFaceID() } : nil
            )
            
            Spacer()
        }
    }
    
    private var lockIcon: String {
        switch vm.mode {
        case .register:
            return "person.fill.badge.plus"
        case .confirm:
            return "lock.rotation"
        case .unlock:
            return "lock.fill"
        }
    }
}

#Preview {
    ContentView()
}

struct PasscodeDots: View {
    let count: Int
    let filledCount: Int
    let success: Bool
    
    var body: some View {
        HStack(spacing: 18) {
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .fill(dotColor(at: i))
                    .frame(width: 16, height: 16)
                    .overlay {
                        Circle()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 1.5)
                    }
                    .scaleEffect(i < filledCount ? 1.1 : 1.0)
                    .animation(.spring(response: 0.25, dampingFraction: 0.6), value: filledCount)
            }
        }
    }
    
    private func dotColor(at index: Int) -> Color {
        if success {
            return Color(hex: "4ADE80")
        }
        return index < filledCount ? .white : .white.opacity(0.25)
    }
}

struct KeyPadButton: View {
    let label: String
    let subtitle: String?
    let action: () -> Void
    
    @State private var pressed = false
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                pressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                    pressed = false
                }
            }
            action()
        } label: {
            VStack(spacing: 1) {
                Text(label)
                    .font(.system(size: 28, weight: .light, design: .rounded))
                    .foregroundStyle(.white)
                
                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.5))
                        .tracking(2)
                }
            }
            .frame(width: 76, height: 76)
            .background(
                Circle()
                    .fill(.white.opacity(pressed ? 0.3 : 0.1))
                    .overlay(Circle().strokeBorder(Color.white.opacity(0.12), lineWidth: 0.5))
            )
            .scaleEffect(pressed ? 0.9 : 1)
        }
    }
}

struct KeyPad: View {
    let onDigit: (String) -> Void
    let onDelete: () -> Void
    let onFaceID: (() -> Void)?
    
    private let rows: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"]
    ]
    
    private let subtitles: [String: String] = [
        "2": "ABC", "3": "DEF", "4": "GHI", "5": "JKL", "6": "MNO", "7": "PQRS", "8": "TUV", "9": "WXYZ"
    ]
    
    var body: some View {
        VStack(spacing: 14) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 18) {
                    ForEach(row, id: \.self) { digit in
                        KeyPadButton(label: digit, subtitle: subtitles[digit]) {
                            onDigit(digit)
                        }
                    }
                }
            }
                
            HStack(spacing: 18) {
                if let faceIDAction = onFaceID {
                    Button(action: faceIDAction) {
                        Image(systemName: "faceid")
                            .font(.system(size: 26, weight: .light))
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(width: 76, height: 76)
                            .background(Circle().fill(Color.white.opacity(0.08)))
                    }
                } else {
                    Spacer().frame(width: 76, height: 76)
                }
                    
                KeyPadButton(label: "0", subtitle: nil) {
                    onDigit("0")
                }
                    
                Button(action: onDelete) {
                    Image(systemName: "delete.left")
                        .font(.system(size: 22, weight: .light))
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(width: 76, height: 76)
                }
            }
        }
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Вы успешно авторизовались! 🎉")
            .font(.system(size: 24, weight: .semibold))
            .foregroundStyle(.white)
    }
}
