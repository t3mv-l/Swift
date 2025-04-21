//
//  CurrentWeatherCollectionViewCellViewModel.swift
//  WeatherForecast
//
//  Created by Артём on 01.04.2025.
//

import WeatherKit
import Foundation

class CurrentWeatherCollectionViewCellViewModel {
    private let model: CurrentWeather
    var result: String = ""
    init(model: CurrentWeather) {
        self.model = model
    }
    
    public func fetchLocation(completion: @escaping () -> Void) {
        LocationManager.shared.getCurrentLocation { location in
            WeatherManager.shared.getWeather(for: location) {
                if let cityName = WeatherManager.shared.locationName {
                    self.result = cityName
                    completion()
                }
            }
        }
    }    
    
    public var condition: String {
        return model.condition.description
    }
    
    public var temperature: String {
        return "\(Int(model.temperature.converted(to: .celsius).value)) °C"
    }
    
    public var iconName: String {
        return model.symbolName
    }
}
