//
//  AttractionCard.swift
//  TrySwiftUI_Maps
//
//  Created by Артём on 01.12.2025.
//

import SwiftUI

struct AttractionCard: View {
    let attraction: Attraction
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(attraction.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 180)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(attraction.name)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text(attraction.description)
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
            }
            .padding()
        }
        .shadow(radius: 10)
    }
}
