//
//  WeatherViewController.swift
//  WeatherForecast
//
//  Created by Артём on 01.04.2025.
//

import WeatherKit
import UIKit

class WeatherViewController: UIViewController {
    private let primaryView = CurrentWeatherView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getLocation()
    }    
    
    private func getLocation() {
        LocationManager.shared.getCurrentLocation { location in
            WeatherManager.shared.getWeather(for: location) { [weak self] in
                DispatchQueue.main.async {
                    guard let currentWeather = WeatherManager.shared.currentWeather else { return }
                    self?.createViewModels(currentWeather: currentWeather)
                }
            }
        }
    }
    
    private func createViewModels(currentWeather: CurrentWeather) {
        primaryView.configure(with: [
            .current(viewModel: .init(model: currentWeather)),
            .hourly(viewModels: WeatherManager.shared.hourlyWeather.compactMap { .init(model: $0)}),
            .daily(viewModels: WeatherManager.shared.dailyWeather.compactMap { .init(model: $0)})
        ])
    }
    
    private func setUpView() {
        view.addSubview(primaryView)
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
