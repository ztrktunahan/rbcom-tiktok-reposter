//
//  StoreReviewHelper.swift
//  HashtagsForInstagramSwift
//
//  Created by Влад Лыков on 03.04.2021.
//

import StoreKit

struct StoreReviewHelper {
    static let userDefaults = UserDefaults.standard
    static func incrementAppStartCounter() {
        let appStartCounter = userDefaults.integer(forKey: SettingsConstants.kLaunchesCount) + 1
        userDefaults.set(appStartCounter, forKey: SettingsConstants.kLaunchesCount)
    }
    static func askForReview() {
        let appStartCounter = userDefaults.integer(forKey: SettingsConstants.kLaunchesCount)
        guard appStartCounter % 5 == 0 else {return}
        SKStoreReviewController.requestReview()
        StoreReviewHelper.incrementAppStartCounter()
    }
}
