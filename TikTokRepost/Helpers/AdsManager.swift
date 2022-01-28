//
//  AdsManager.swift
//  TimetableSwift
//
//  Created by Влад Лыков on 15.01.2021.
//

import UIKit

class AdsManager {

    static let shared = AdsManager()


        
    func showInterstitialAd(from vc: UIViewController) {

        guard !Settings.shared.isPremium else {return}
       
        
    }
    
}
