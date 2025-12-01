//
//  ContentView.swift
//  TrySwiftUI_Maps
//
//  Created by Артём on 24.08.2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    //span - это масштаб; чем меньше значения дельт, тем меньший участок карты отобразится
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.9398, longitude: 30.3088), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State private var mapType: MKMapType = .standard
    @State private var searchText = ""
    @State private var selectedAttraction: Attraction?
    
    let attractions = [
        Attraction(name: "Peter and Paul Fortress",
                   description: "Saint Petersburg began here",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9498, longitude: 30.3163),
                   span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01),
                   imageName: "peter_and_paul"),
        Attraction(name: "Hermitage Museum",
                   description: "The city's main museum",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9401, longitude: 30.3142),
                   span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01),
                   imageName: "hermitage"),
        Attraction(name: "Nevsky Prospect",
                   description: "The city's main street",
                   coordinate: CLLocationCoordinate2D(latitude: 59.93455, longitude: 30.33245),
                   span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01),
                   imageName: "nevsky"),
        Attraction(name: "Saint Isaac's Cathedral",
                   description: "A large architectural landmark cathedral",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9341, longitude: 30.3066),
                   span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007),
                   imageName: "isaac"),
        Attraction(name: "Summer Garden",
                   description: "A monument of landscape architecture",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9445, longitude: 30.335),
                   span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007),
                   imageName: "letniy"),
        Attraction(name: "Russian Museum",
                   description: "The largest depository of Russian fine art",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9383, longitude: 30.3321),
                   span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003),
                   imageName: "russian_museum"),
        Attraction(name: "Kunstkamera",
                   description: "The museum known for its \"grotesques\"",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9418, longitude: 30.3047),
                   span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004),
                   imageName: "kunst"),
        Attraction(name: "Kazan Cathedral",
                   description: "One of the most beautiful Orthodox cathedrals",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9343, longitude: 30.3248),
                   span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003),
                   imageName: "kazan"),
        Attraction(name: "Mariinsky Theatre",
                   description: "The main city's theatre",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9253, longitude: 30.2961),
                   span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004),
                   imageName: "mariinka"),
        Attraction(name: "Church of the Savior on Blood",
                   description: "A place where the Emperor Alexander II was killed",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9400, longitude: 30.3289),
                   span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003),
                   imageName: "spas"),
        Attraction(name: "Gazprom Arena",
                   description: "The FC Zenit's home stadium",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9727, longitude: 30.2205),
                   span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007),
                   imageName: "zenit"),
        Attraction(name: "Lakhta Center",
                   description: "The tallest building in the entire Europe",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9872, longitude: 30.1773),
                   span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007),
                   imageName: "lahta"),
        Attraction(name: "Sevkabel Port",
                   description: "City's new sightseeing with stunning sea views",
                   coordinate: CLLocationCoordinate2D(latitude: 59.9243, longitude: 30.2411),
                   span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005),
                   imageName: "sevcabel")
    ]
    
    var filteredAttractions: [Attraction] {
        if searchText.isEmpty {
            return attractions
        } else {
            return attractions.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            MapView(region: region, mapType: mapType)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.leading, 10)
                    
                    TextField("Search locations", text: $searchText)
                        .padding(.vertical, 10)
                        .foregroundStyle(.white)
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.black.opacity(0.3))
                        .blur(radius: 2)
                )
                .padding(.horizontal)
                .padding(.top, 20)
                
                HStack(spacing: 20) {
                    Button {
                        updateToCurrentLocation()
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding()
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .shadow(radius: 10)
                    }
                    
                    Button {
                        if let peterAndPaulFortress = attractions.first(where: {$0.name == "Peter and Paul Fortress"}) {
                            withAnimation {
                                region.center = peterAndPaulFortress.coordinate
                            }
                        }
                    } label: {
                        Image(systemName: "binoculars.fill")
                            .font(.title2)
                            .padding()
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.orange, .red],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .shadow(radius: 10)
                    }
                    
                    Button {
                        //toggleMapType()
                    } label: {
                        Image(systemName: "map")
                            .font(.title2)
                            .padding()
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .blue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .shadow(radius: 10)
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal)
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(filteredAttractions) { attraction in
                            AttractionCard(attraction: attraction)
                                .onTapGesture {
                                    selectedAttraction = attraction
                                    withAnimation {
                                        region.center = attraction.coordinate
                                        region.span = attraction.span
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    func updateToCurrentLocation() {
        withAnimation {
            region.center = CLLocationCoordinate2D(latitude: 59.931, longitude: 30.362)
            region.span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        }
    }
}

#Preview {
    ContentView()
}
