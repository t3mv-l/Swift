//
//  MyViewController.swift
//  Settings_UIKit
//
//  Created by Артём on 18.04.2025.
//

import UIKit

class MyViewController: UIViewController {
    // MARK: - Making a custom image
    private func createRoundImage(with text: String, size: CGSize) -> UIImage? {
        let diameter = min(size.width, size.height)
    
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
    
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        context.setFillColor(UIColor.systemGray.cgColor)
        context.fillEllipse(in: rect)
    
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ]
    
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let textSize = attributedText.size()
    
        let textX = (diameter - textSize.width) / 2
        let textY = (diameter - textSize.height) / 2
        attributedText.draw(at: CGPoint(x: textX, y: textY))
    
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    let imageSize = CGSize(width: 50, height: 50)
    private lazy var roundImage: UIImage? = createRoundImage(with: "АЛ", size: imageSize)
    
    // MARK: - Initializing the sections
    lazy var zeroSection: [SettingsInfo] = [SettingsInfo(systemPic: roundImage, title: "Артём Легостинов", subtitle: "Аккаунт Apple, iCloud и другое")]
    
    lazy var firstSection: [SettingsInfo] = [SettingsInfo(systemPic: UIImage(systemName: "airplane"), title: "Авиарежим", subtitle: ""),
                                        SettingsInfo(systemPic: UIImage(systemName: "wifi"), title: "WLAN", subtitle: "107"),
                                        SettingsInfo(systemPic: UIImage(systemName: "link"), title: "Bluetooth", subtitle: "Вкл."),
                                        SettingsInfo(systemPic: UIImage(systemName: "point.3.connected.trianglepath.dotted"), title: "Сотовая связь", subtitle: ""),
                                        SettingsInfo(systemPic: UIImage(systemName: "battery.100percent"), title: "Аккумулятор", subtitle: ""),
                                        SettingsInfo(systemPic: UIImage(systemName: "globe"), title: "VPN", subtitle: "")]
    
    lazy var secondSection: [SettingsInfo] = [SettingsInfo(systemPic: UIImage(systemName: "gear"), title: "Основные", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "figure"), title: "Универсальный доступ", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "camera"), title: "Камера", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "button.vertical.left.press"), title: "Кнопка действия", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "circles.hexagongrid"), title: "Обои", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "timer"), title: "Ожидание", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "magnifyingglass"), title: "Поиск", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "slider.horizontal.2.square"), title: "Пункт управления", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "iphone.app.switcher"), title: "Экран \"Домой\" и библиотека приложений", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "sun.max"), title: "Экран и яркость", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "waveform"), title: "Siri", subtitle: "")]
    
    lazy var thirdSection: [SettingsInfo] = [SettingsInfo(systemPic: UIImage(systemName: "bell.badge"), title: "Уведомления", subtitle: ""),
                                        SettingsInfo(systemPic: UIImage(systemName: "speaker.wave.3"), title: "Звуки и вибрация", subtitle: ""),
                                        SettingsInfo(systemPic: UIImage(systemName: "moon"), title: "Фокусирование", subtitle: ""),
                                        SettingsInfo(systemPic: UIImage(systemName: "hourglass"), title: "Экранное время", subtitle: "")]
    
    lazy var fourthSection: [SettingsInfo] = [SettingsInfo(systemPic: UIImage(systemName: "faceid"), title: "Face ID и код-пароль", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "sos"), title: "Экстренный вызов - SOS", subtitle: ""),
                                         SettingsInfo(systemPic: UIImage(systemName: "hand.raised"), title: "Конфиденциальность и безопасность", subtitle: "")]
    
    lazy var fifthSection: [SettingsInfo] = [SettingsInfo(systemPic: UIImage(systemName: "gamecontroller"), title: "Game Center", subtitle: ""),
                                        SettingsInfo(systemPic: UIImage(systemName: "cloud"), title: "iCloud", subtitle: ""),
                                        SettingsInfo(systemPic: UIImage(systemName: "wallet.bifold"), title: "Wallet и Apple Pay", subtitle: "")]
    
    lazy var sixthSection: [SettingsInfo] = [SettingsInfo(systemPic: UIImage(systemName: "apps.iphone"), title: "Приложения", subtitle: "")]
    
    var filteredSections: [SettingsInfo] = []
    
    lazy var allSections: [SettingsInfo] = {
        var allSections = [SettingsInfo]()
        allSections.append(contentsOf: zeroSection)
        allSections.append(contentsOf: firstSection)
        allSections.append(contentsOf: secondSection)
        allSections.append(contentsOf: thirdSection)
        allSections.append(contentsOf: fourthSection)
        allSections.append(contentsOf: fifthSection)
        allSections.append(contentsOf: sixthSection)
        return allSections
    }()
    
    // MARK: - Initializing tableView and searchController
    lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return $0
    }(UITableView(frame: view.frame, style: .insetGrouped))
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.placeholder = "Поиск"
        return controller
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Настройки"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
}
