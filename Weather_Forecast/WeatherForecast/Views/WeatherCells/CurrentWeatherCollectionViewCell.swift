//
//  CurrentWeatherCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Артём on 01.04.2025.
//

import UIKit

class CurrentWeatherCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "CurrentWeatherCollectionViewCell"
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40, weight: .bold)
        return label
    }()

    private let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 62, weight: .medium)
        return label
    }()

    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 34, weight: .regular)
        return label
    }()

    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(locationLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(icon)
        contentView.addSubview(conditionLabel)

        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            locationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            locationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            tempLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            tempLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            tempLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            icon.heightAnchor.constraint(equalToConstant: 55),
            icon.widthAnchor.constraint(equalToConstant: 55),
            icon.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
            icon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            conditionLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10),
            conditionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
            conditionLabel.heightAnchor.constraint(equalToConstant: 80),
            conditionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 15),
            conditionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        locationLabel.text = nil
        conditionLabel.text = nil
        tempLabel.text = nil
        icon.image = nil
    }

    public func configure(with viewModel: CurrentWeatherCollectionViewCellViewModel) {
        viewModel.fetchLocation {
            DispatchQueue.main.async {
                self.locationLabel.text = viewModel.result
            }
        }
        icon.image = UIImage(systemName: viewModel.iconName)
        conditionLabel.text = viewModel.condition
        tempLabel.text = viewModel.temperature
    }
}
