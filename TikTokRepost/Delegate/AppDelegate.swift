//
//  AppDelegate.swift
//  HashtagsForInstagramSwift
//
//  Created by Влад Лыков on 01.02.2021.
//

import UIKit
import CoreData
import AVKit
import Purchases
import Adjust
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        
        FirebaseApp.configure()
       
        StoreKitOperations().configureStoreKit()
        get_prices_from_uDefaults()
        StoreKitOperations().setPrices()
        
        
        
         rememberUser()
            
     
        
        //verifyPremium()
    

//        GADMobileAds.sharedInstance().start(completionHandler: nil)

       // loadDefaultHashtagsToCoreData()
        
        Settings.shared.setupAppearance()
        
        StoreReviewHelper.incrementAppStartCounter()
                      
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
                
        return true
    }
    
    func rememberUser(){
        
        
       
    let user = uDefaults.object(forKey: "userFirst")
    
     
        if let  premium = uDefaults.value(forKey: "isUserPremium") as? Bool{
            isUserPremium = premium
        }
     
        
    if user != nil {
      
        print("dfsfsdsf", user!)
        
      let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
     
        if isUserPremium {
            
            let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let VC1 = board.instantiateViewController(withIdentifier: "RepostVC") as! RepostController
            window?.rootViewController = VC1
            
        }else{
            
       
            
            let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let VC1 = board.instantiateViewController(withIdentifier: "inAppVC") as! inAppVC
            window?.rootViewController = VC1
            
        }
      
     }
}
 
    func get_prices_from_uDefaults(){
       if let price_monthly_uDefault = uDefaults.object(forKey: "priceMonthly") as? String{
         priceMonthly = price_monthly_uDefault
       }
       if let price_annual_uDefault = uDefaults.object(forKey: "priceAnnual") as? String{
        priceAnnual = price_annual_uDefault
     }
    
    func verifyPremium() {
        
        guard let premiumID = Settings.shared.premiumID, Settings.shared.isPremium else {return}
    
        
    }
        
       
    func loadDefaultHashtagsToCoreData() {
        
        let isLoaded = Database.shared.isEntityExist("Hashtag")
        
        if !isLoaded {
                          
            let titlesString = load(file: "Titles")
            var titles = titlesString.components(separatedBy: "\n")
            
            let hashtagsString = load(file: "Hashtags")
            var hashtags = hashtagsString.components(separatedBy: "\n")
            
            titles.removeLast()
            hashtags.removeLast()

            for i in 0..<titles.count {
                                
                let hashtag = NSEntityDescription.insertNewObject(forEntityName: "Hashtag", into: Database.shared.context) as? Hashtag
                
                hashtag?.title = titles[i]
                hashtag?.tags = hashtags[i]
                hashtag?.defaultTag = true
                
            }
            
            Database.shared.saveContext()
            
        }
        
        
    }
        func initAdjust(){
            
            let appToken = "688t5zdxisqo"
            let environment = ADJEnvironmentProduction
            let adjustConfig = ADJConfig(appToken: appToken, environment: environment)
            adjustConfig?.logLevel = ADJLogLevelVerbose
            Adjust.appDidLaunch(adjustConfig!)
            
            Purchases.shared.collectDeviceIdentifiers()
            
            // Set the Adjust Id on app launch if it exists
               if let adjustId = Adjust.adid() {
                   Purchases.shared.setAdjustID(adjustId)
               
               }
            
        }
    

    func load(file name:String) -> String {

        if let path = Bundle.main.path(forResource: name, ofType: "txt") {

            if let contents = try? String(contentsOfFile: path) {
                return contents
            } else {
                print("Error! - This file doesn't contain any text.")
            }

        } else {
            print("Error! - This file doesn't exist.")
        }

        return ""
    }
    
}

}

