//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 05.10.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    @IBOutlet weak var classicContainerView: UIView!
    @IBOutlet weak var classicNameLabel: UILabel!
    
    @IBOutlet weak var dayContainerView: UIView!
    @IBOutlet weak var dayNameLabel: UILabel!
    
    @IBOutlet weak var nightContainerView: UIView!
    @IBOutlet weak var nightNameLabel: UILabel!
    
    @IBOutlet var bubbleViews: [UIView]!

    weak var delegate: ThemesPickerDelegate?
    var setTheme: ((ThemeModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.navigationItem.largeTitleDisplayMode = .never
        
        classicContainerView.layer.cornerRadius = 14
        classicContainerView.layer.borderWidth = 1
        classicContainerView.layer.borderColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1).cgColor
        
        dayContainerView.layer.cornerRadius = 14
        dayContainerView.layer.borderWidth = 1
        dayContainerView.layer.borderColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1).cgColor
        
        nightContainerView.layer.cornerRadius = 14
        nightContainerView.layer.borderWidth = 1
        nightContainerView.layer.borderColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1).cgColor
        
        for bubble in bubbleViews {
            bubble.layer.cornerRadius = 10
        }
        
        let tapOnClassicThemeContainer = UITapGestureRecognizer(target: self, action: #selector(setClassicTheme))
        classicContainerView.addGestureRecognizer(tapOnClassicThemeContainer)
        let tapOnClassicThemeName = UITapGestureRecognizer(target: self, action: #selector(setClassicTheme))
        classicNameLabel.addGestureRecognizer(tapOnClassicThemeName)
        classicNameLabel.isUserInteractionEnabled = true
        
        let tapOnDayThemeContainer = UITapGestureRecognizer(target: self, action: #selector(setDayTheme))
        dayContainerView.addGestureRecognizer(tapOnDayThemeContainer)
        let tapOnDayThemeName = UITapGestureRecognizer(target: self, action: #selector(setDayTheme))
        dayNameLabel.addGestureRecognizer(tapOnDayThemeName)
        dayNameLabel.isUserInteractionEnabled = true
        
        let tapOnNightThemeContainer = UITapGestureRecognizer(target: self, action: #selector(setNightTheme))
        nightContainerView.addGestureRecognizer(tapOnNightThemeContainer)
        let tapOnNightThemeName = UITapGestureRecognizer(target: self, action: #selector(setNightTheme))
        nightNameLabel.addGestureRecognizer(tapOnNightThemeName)
        nightNameLabel.isUserInteractionEnabled = true
        
        configureTheme()
    }
    
    @objc private func setClassicTheme() {
        // delegate?.setTheme(ClassicTheme())
        self.setTheme?(ClassicTheme())
        saveTheme(.classic)
        
        setupClassic(border: 3, color: .systemBlue)
        setupDay(border: 1, color: .gray)
        setupNight(border: 1, color: .gray)
    }
    
    @objc private func setDayTheme() {
        // delegate?.setTheme(DayTheme())
        self.setTheme?(DayTheme())
        saveTheme(.day)
        
        setupDay(border: 3, color: .systemBlue)
        setupClassic(border: 1, color: .gray)
        setupNight(border: 1, color: .gray)
    }
    
    @objc private func setNightTheme() {
        // delegate?.setTheme(NightTheme())
        self.setTheme?(NightTheme())
        saveTheme(.night)
        
        setupNight(border: 3, color: .systemBlue)
        setupClassic(border: 1, color: .gray)
        setupDay(border: 1, color: .gray)
    }
    
    private func setupClassic(border: CGFloat, color: UIColor) {
        classicContainerView.layer.borderWidth = border
        classicContainerView.layer.borderColor = color.cgColor
    }
    
    private func setupDay(border: CGFloat, color: UIColor) {
        dayContainerView.layer.borderWidth = border
        dayContainerView.layer.borderColor = color.cgColor
    }
    
    private func setupNight(border: CGFloat, color: UIColor) {
        nightContainerView.layer.borderWidth = border
        nightContainerView.layer.borderColor = color.cgColor
    }
    
    private func saveTheme(_ theme: CurrentTheme) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(theme.rawValue, forKey: "Theme")
        
        configureTheme()
    }
    
    private func configureTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
        
        classicNameLabel.textColor = Theme.current.textColor
        dayNameLabel.textColor = Theme.current.textColor
        nightNameLabel.textColor = Theme.current.textColor
        
        switch Theme.current {
        case is ClassicTheme:
            setupClassic(border: 3, color: .systemBlue)
            setupDay(border: 1, color: .gray)
            setupNight(border: 1, color: .gray)
        case is DayTheme:
            setupDay(border: 3, color: .systemBlue)
            setupClassic(border: 1, color: .gray)
            setupNight(border: 1, color: .gray)
        case is NightTheme:
            setupNight(border: 3, color: .systemBlue)
            setupDay(border: 1, color: .gray)
            setupClassic(border: 1, color: .gray)
        default:
            return
        }
    }
    
}

enum CurrentTheme: String {
    case classic
    case day
    case night
}
