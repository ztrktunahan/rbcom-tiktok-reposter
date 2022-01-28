//
//  Settings.swift
//  TimetableSwift
//
//  Created by Влад Лыков on 13.01.2021.
//

import UIKit

enum MediaSort: Int {
    case byNew = 0
    case byOld = 1
}

class SettingsNavBar: UINavigationBar {}

class Settings {

    static let shared = Settings()
    
    let userDefaults: UserDefaults = UserDefaults.standard
    
    var mainColor = UIColor.red
    
    var username: String? {
        set {userDefaults.set(newValue, forKey: SettingsConstants.kUsername)}
        get {userDefaults.string(forKey: SettingsConstants.kUsername)}
    }
    
    var premiumID: String? {
        set {userDefaults.set(newValue, forKey: SettingsConstants.kPremiumID)}
        get {userDefaults.string(forKey: SettingsConstants.kPremiumID)}
    }
    
    var isPremium: Bool {
        set {userDefaults.set(newValue, forKey: SettingsConstants.kPremium)}
        get {userDefaults.bool(forKey: SettingsConstants.kPremium)}
    }
    
    var autoTheme: Bool {
        set {userDefaults.set(newValue, forKey: SettingsConstants.kAutoTheme)}
        get {userDefaults.bool(forKey: SettingsConstants.kAutoTheme)}
    }
    
    var tapticEngine: Bool {
        set {userDefaults.set(newValue, forKey: SettingsConstants.kTapticEngine)}
        get {userDefaults.bool(forKey: SettingsConstants.kTapticEngine)}
    }
    
    var tapticStyle: Int {
        set {userDefaults.set(newValue, forKey: SettingsConstants.kTapticStyle)}
        get {userDefaults.integer(forKey: SettingsConstants.kTapticStyle)}
    }
    
    var interfaceStyle: Int {
        set {userDefaults.set(newValue, forKey: SettingsConstants.kInterfaceStyle)}
        get {userDefaults.integer(forKey: SettingsConstants.kInterfaceStyle)}
    }
    
    var launchesCount: Int {
        set {userDefaults.set(newValue, forKey: SettingsConstants.kLaunchesCount)}
        get {userDefaults.integer(forKey: SettingsConstants.kLaunchesCount)}
    }
    
    var mediaSort: Int {
        set {userDefaults.set(newValue, forKey: SettingsConstants.kMediaSort)}
        get {userDefaults.integer(forKey: SettingsConstants.kMediaSort)}
    }
    
    var repostsCount: Int {
        set {userDefaults.set(newValue, forKey: SettingsConstants.kRepostsCount)}
        get {userDefaults.integer(forKey: SettingsConstants.kRepostsCount)}
    }
    
    func setupAppearance() {
        
        UITabBar.appearance().tintColor = mainColor
        UIBarButtonItem.appearance().tintColor = mainColor
        UISwitch.appearance().onTintColor = mainColor
        UITableViewCell.appearance().tintColor = mainColor
        UINavigationBar.appearance().tintColor = mainColor
        UISegmentedControl.appearance().tintColor = mainColor
        
        if #available(iOS 13.0, *) {
            UISegmentedControl.appearance().selectedSegmentTintColor = mainColor
        }

        PlusButton.appearance().tintColor = mainColor
        
    }
    
    init() {
                        
        let colorData = AppConfig.defaultColor.encode() ?? Data()

        userDefaults.register(defaults:
                                [SettingsConstants.kTapticEngine     : true,
                                 SettingsConstants.kAutoTheme        : true,
                                 SettingsConstants.kMediaSort        : MediaSort.byNew.rawValue,
                                 SettingsConstants.kMainColor        : colorData,
                                 SettingsConstants.kTapticStyle      : 0,
                                 SettingsConstants.kRepostsCount     : 0,
                                 SettingsConstants.kInterfaceStyle   : 1])

    }
    
}

// MARK: SettingsConstants

struct SettingsConstants {
    static let kTapticEngine   = "tapticEngine"
    static let kTapticStyle    = "tapticStyle"
    static let kInterfaceStyle = "interfaceStyle"
    static let kAutoTheme      = "autoTheme"
    static let kLaunchesCount  = "launchesCount"
    static let kMainColor      = "mainColor"
    static let kMediaSort      = "mediaeSort"
    static let kPremium        = "isPremium"
    static let kPremiumID      = "premiumID"
    static let kRepostsCount   = "repostsCount"
    static let kUsername       = "username"
}
