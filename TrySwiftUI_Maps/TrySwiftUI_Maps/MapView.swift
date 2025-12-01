//
//  MapView.swift
//  TrySwiftUI_Maps
//
//  Created by Артём on 01.12.2025.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var region: MKCoordinateRegion
    var mapType: MKMapType = .standard
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(region, animated: false)
        mapView.mapType = mapType
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.mapType = mapType
    }
}
