//
//  AppConfig.swift
//  VKStatisticsSwift
//
//  Created by Влад Лыков on 19.02.2021.
//

import UIKit

struct AppConfig {
    
    static let freeRepostsCount: Int = 3

    static let defaultColor: UIColor = .systemPink
    
    static let adMobInterstitialID: String = ""

    static let appID: String = ""
    static let developerID: String = ""
    
    static let supportEmail: String = ""
       
    static let premiumID: String = ""
    static let sharedSecret: String = ""
    
    static let privacyPolicyURL: String = ""
    static let termsOfUseURL: String = ""
    
    static let allowVideoFeedRefresh: Bool = true

    static let genericErrorTitle: String = "Oops"
    static let genericErrorMessage: String = "Something went wrong. We couldn't load videos. Please try again later"
    
    static let halfSize = CGSize(width: (UIScreen.main.bounds.width/2 - 10), height: (UIScreen.main.bounds.width/2 - 10)/1.5)
    static let fullSize = CGSize(width: (UIScreen.main.bounds.width - 20), height: (UIScreen.main.bounds.width/2 - 10)/1.5)
    
    static let videoFeedTimeout: Double = 35
    
}
