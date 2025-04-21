//
//  WeatherManager.swift
//  WeatherForecast
//
//  Created by Артём on 01.04.2025.
//

import CoreLocation
import Foundation
import WeatherKit

final class WeatherManager {
    static let shared = WeatherManager()
    let locale = Locale(identifier: "en-US")
    
    let service = WeatherService.shared
    private let geocoder = CLGeocoder()
    
    public private(set) var currentWeather: CurrentWeather?
    public private(set) var hourlyWeather: [HourWeather] = []
    public private(set) var dailyWeather: [DayWeather] = []
    public private(set) var locationName: String?
    
    private init() {}
    
    public func getWeather(for location: CLLocation, completion: @escaping () -> Void) {
        Task {
            do {
                let result = try await service.weather(for: location)
                print("Current: \(result.currentWeather)")
                print("Hourly: \(result.hourlyForecast)")
                print("Daily: \(result.dailyForecast)")
                self.currentWeather = result.currentWeather
                self.hourlyWeather = result.hourlyForecast.forecast
                self.dailyWeather = result.dailyForecast.forecast
                
                self.getLocationName(for: location, locale: locale)
                completion()
            } catch {
                print(String(describing: error))
            }
        }
    }
    
    private func getLocationName(for location: CLLocation, locale: Locale) {
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { (placemarks, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("Can't find the location")
                return
            }
            
            self.locationName = placemark.locality ?? placemark.name
            print("Location name: \(self.locationName ?? "Unknown")")
        }
    }
}
