//
//  Attraction.swift
//  TrySwiftUI_Maps
//
//  Created by Артём on 01.12.2025.
//

import Foundation
import MapKit

struct Attraction: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let span: MKCoordinateSpan
    let imageName: String
}
