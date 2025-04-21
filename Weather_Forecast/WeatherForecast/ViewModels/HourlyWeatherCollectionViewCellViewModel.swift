//
//  HourlyWeatherCollectionViewCellViewModel.swift
//  WeatherForecast
//
//  Created by Артём on 01.04.2025.
//

import WeatherKit
import Foundation

struct HourlyWeatherCollectionViewCellViewModel {
    private let model: HourWeather
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    init(model: HourWeather) {
        self.model = model
    }
    
    public var iconName: String {
        return model.symbolName
    }
    
    public var temperature: String {
        return "\(Int(model.temperature.converted(to: .celsius).value)) °C"
    }
    
    public var hour: String {
        let hour = Calendar.current.component(.hour, from: model.date)
        return "\(hour):00"
    }
}
