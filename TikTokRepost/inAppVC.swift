//
//  inAppVC.swift
//  TikTokRepost
//
//  Created by ege on 13.09.2021.
//

import UIKit
import Hero
import Purchases
import Adjust
import Firebase

class inAppVC: UIViewController {
    
    var choosen = false
    var isAnnualSelected = false
    var isMonthlySelected = false
    let monthlyPlanButton = UIButton()
    let annualPlanButton = UIButton()


 

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        let stringMultiplier = 0.00115 * screenHeight
        
        
        view.backgroundColor = .white
        
        let inAppBackground = UIImageView()
        inAppBackground.image = UIImage(named: "img_inapp")
        inAppBackground.frame = CGRect(x: 0.2 * screenWidth, y: 0.1 * screenHeight, width: 0.6 * screenWidth, height: 0.3 * screenHeight)
        view.addSubview(inAppBackground)
        
        let backButton = UIButton()
        backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        backButton.setBackgroundImage(UIImage(named: "btn_cross"), for: UIControl.State.normal)
        backButton.frame = CGRect(x: 0.868 * screenWidth, y: 0.065 * screenHeight, width: 0.060 * screenWidth, height: 0.028 * screenHeight)
        backButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        backButton.layer.shadowRadius = 5
        backButton.layer.shadowOpacity = 1.4
        backButton.contentVerticalAlignment.self = .center
        backButton.contentHorizontalAlignment.self = .center
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: UIControl.Event.touchUpInside)
        
        let title = UILabel()
        title.textColor = UIColor(red:0.00, green:0.02, blue:0.26, alpha:1.0)
        title.text = NSLocalizedString("Unlock Premium Features", comment: "")
        title.textAlignment = .center
        title.font = UIFont(name: "Poppins-Bold", size: 22 * stringMultiplier)
        title.frame = CGRect(x: 0.145 * screenWidth, y: 0.4 * screenHeight, width: 0.737 * screenWidth, height: 0.060 * screenHeight)
        view.addSubview(title)

        
        let subtitle = UILabel()
        subtitle.textColor = UIColor(red:0.00, green:0.02, blue:0.26, alpha:1.0)
        subtitle.text = NSLocalizedString("Repost Unlimited Videos on Tiktok", comment: "")
        subtitle.textAlignment = .center
        subtitle.font = UIFont(name: "Poppins-Regular", size: 18 * stringMultiplier)
        subtitle.frame = CGRect(x: 0.1 * screenWidth, y: 0.45 * screenHeight, width: 0.8 * screenWidth, height: 0.134 * screenHeight)
        subtitle.numberOfLines = 4
        view.addSubview(subtitle)
       
        // MONTHLY PLAN
        
        monthlyPlanButton.setBackgroundImage(UIImage(named: "btn_monthly"), for: UIControl.State.normal)
        monthlyPlanButton.frame = CGRect(x: 0.05 * screenWidth, y: 0.6 * screenHeight, width: 0.45 * screenWidth, height: 0.2 * screenHeight)
        view.addSubview(monthlyPlanButton)
        monthlyPlanButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        monthlyPlanButton.layer.shadowRadius = 5
        monthlyPlanButton.layer.shadowOpacity = 1.4
        monthlyPlanButton.addTarget(self, action: #selector(monthlyPlanButtonClicked), for: UIControl.Event.touchUpInside)
        
        let monthlyPlanLabel = UILabel()
        monthlyPlanLabel.textColor = .black
        monthlyPlanLabel.text = NSLocalizedString("Monthly Plan", comment: "")
        monthlyPlanLabel.textAlignment = .center
        monthlyPlanLabel.font = UIFont(name: "Poppins-Medium", size: 18 * stringMultiplier)
        monthlyPlanLabel.frame = CGRect(x: 0.13 * screenWidth, y: 0.68 * screenHeight, width: 0.3 * screenWidth, height: 0.072 * screenHeight)
        view.addSubview(monthlyPlanLabel)
        
        let monthlyPriceLabel = UILabel()
        monthlyPriceLabel.textColor = .black
        monthlyPriceLabel.text = NSLocalizedString("$9.99", comment: "")
        monthlyPriceLabel.textAlignment = .center
        monthlyPriceLabel.font = UIFont(name: "Poppins-Medium", size: 20 * stringMultiplier)
        monthlyPriceLabel.frame = CGRect(x: 0.13 * screenWidth, y: 0.72 * screenHeight, width: 0.3 * screenWidth, height: 0.072 * screenHeight)
        view.addSubview(monthlyPriceLabel)
        //ANNUAL PLANI!
        
        annualPlanButton.setBackgroundImage(UIImage(named: "btn_annual"), for: UIControl.State.normal)
        annualPlanButton.frame = CGRect(x: 0.5 * screenWidth, y: 0.6 * screenHeight, width: 0.45 * screenWidth, height: 0.2 * screenHeight)
        annualPlanButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        annualPlanButton.layer.shadowRadius = 5
        annualPlanButton.layer.shadowOpacity = 1.4
        view.addSubview(annualPlanButton)
        annualPlanButton.addTarget(self, action: #selector(annualPlanButtonClicked), for: UIControl.Event.touchUpInside)
        
        let annualPlanLabel = UILabel()
        annualPlanLabel.textColor = .black
        annualPlanLabel.text = NSLocalizedString("Annual Plan", comment: "")
        annualPlanLabel.textAlignment = .center
        annualPlanLabel.font = UIFont(name: "Poppins-Medium", size: 18 * stringMultiplier)
        annualPlanLabel.frame = CGRect(x: 0.58 * screenWidth, y: 0.68 * screenHeight, width: 0.3 * screenWidth, height: 0.072 * screenHeight)
        view.addSubview(annualPlanLabel)
        
        let annualPriceLabel = UILabel()
        annualPriceLabel.textColor = .black
        annualPriceLabel.text = NSLocalizedString("$24.99", comment: "")
        annualPriceLabel.textAlignment = .center
        annualPriceLabel.font = UIFont(name: "Poppins-Medium", size: 20 * stringMultiplier)
        annualPriceLabel.frame = CGRect(x: 0.58 * screenWidth, y: 0.72 * screenHeight, width: 0.3 * screenWidth, height: 0.072 * screenHeight)
        view.addSubview(annualPriceLabel)
        
        
        //START BUTONU
        
        
        let startButton = UIButton()
        startButton.setTitle(NSLocalizedString("Start", comment: ""), for: UIControl.State.normal)
        startButton.setBackgroundImage(UIImage(named: "btn_next"), for: UIControl.State.normal)
        startButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        startButton.frame = CGRect(x: 0.075 * screenWidth, y: 0.83 * screenHeight, width: 0.85 * screenWidth, height: 0.072 * screenHeight)
        startButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
            startButton.layer.shadowRadius = 5
            startButton.layer.shadowOpacity = 1.4
        startButton.contentVerticalAlignment.self = .center
        startButton.contentHorizontalAlignment.self = .center
        startButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 20 * stringMultiplier)
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonClicked), for: UIControl.Event.touchUpInside)
        
        // Odemeler CGRect(x: 0.070 * screenWidth, y: 0.950 * screenHeight, width: 0.870 * screenWidth, height: 0.080 * screenHeight)
        
        let privacyButton = UIButton()
        privacyButton.setTitle(NSLocalizedString("Privacy Policy", comment: ""), for: UIControl.State.normal)
        privacyButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        privacyButton.frame = CGRect(x: 0.106 * screenWidth, y: 0.91 * screenHeight, width: 0.3 * screenWidth, height: 0.080 * screenHeight)
        privacyButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        privacyButton.layer.shadowRadius = 5
        privacyButton.layer.shadowOpacity = 1.4
        privacyButton.contentVerticalAlignment.self = .center
        privacyButton.contentHorizontalAlignment.self = .left
        privacyButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12 * stringMultiplier)
        view.addSubview(privacyButton)
        privacyButton.addTarget(self, action: #selector(privacyButtonClicked), for: UIControl.Event.touchUpInside)
    
        
        let termsButton = UIButton()
        termsButton.setTitle(NSLocalizedString("Terms of Use", comment: ""), for: UIControl.State.normal)
        termsButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
     
        termsButton.frame = CGRect(x: 0.606 * screenWidth, y: 0.91 * screenHeight, width: 0.3 * screenWidth, height: 0.080 * screenHeight)
        termsButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        termsButton.layer.shadowRadius = 5
        termsButton.layer.shadowOpacity = 1.4
        termsButton.contentVerticalAlignment.self = .center
        termsButton.contentHorizontalAlignment.self = .right
        termsButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12 * stringMultiplier)
        view.addSubview(termsButton)
        termsButton.addTarget(self, action: #selector(termsButtonClicked), for: UIControl.Event.touchUpInside)
        
        let restoreButton = UIButton()
        restoreButton.setTitle(NSLocalizedString("Restore", comment: ""), for: UIControl.State.normal)
        restoreButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        restoreButton.frame = CGRect(x: 0.35 * screenWidth, y: 0.91 * screenHeight, width: 0.3 * screenWidth, height: 0.080 * screenHeight)
        restoreButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        restoreButton.layer.shadowRadius = 5
        restoreButton.layer.shadowOpacity = 1.4
        restoreButton.contentVerticalAlignment.self = .center
        restoreButton.contentHorizontalAlignment.self = .center
        restoreButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 12 * stringMultiplier)
        view.addSubview(restoreButton)
        restoreButton.addTarget(self, action: #selector(restoreButtonClicked), for: UIControl.Event.touchUpInside)
        
        setDefaultSize(view: view)
        StoreKitOperations().setPrices()
        monthlyPriceLabel.text =  priceMonthly
        annualPriceLabel.text = priceAnnual
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            StoreKitOperations().setPrices()
            
            monthlyPriceLabel.text = priceMonthly
            annualPriceLabel.text = priceAnnual
            

        }
        
        
        monthlyPlanButton.addTarget(self, action: #selector(monthlyPlanButtonClicked), for: UIControl.Event.touchUpInside)
        annualPlanButton.addTarget(self, action: #selector(annualPlanButtonClicked), for: UIControl.Event.touchUpInside)
        startButton.addTarget(self, action: #selector(startButtonClicked), for: UIControl.Event.touchUpInside)


   

        
        
    }
    
    @objc func termsButtonClicked() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if let url = URL(string: "https://www.appforce.xyz/terms-and-conditions-tik-saver") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
    }
        
        @objc func restoreButtonClicked() {
            
            StoreKitOperations().restorePurchase(viewController : self)
         
        }
    @objc func privacyButtonClicked() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if let url = URL(string: "https://www.appforce.xyz/privacy-policy-tik-saver") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
}
    @objc func backButtonClicked() {
        
        let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let VC1 = board.instantiateViewController(withIdentifier: "RepostVC") as! RepostController
        self.present(VC1, animated:true, completion: nil)
        
         }
    @objc func monthlyPlanButtonClicked() {
        
                if isAnnualSelected {
                  isAnnualSelected = false
                   
                    annualPlanButton.setBackgroundImage(UIImage(named: "btn_annual"), for: .normal)
                   
                  isMonthlySelected = true
                   
                    monthlyPlanButton.setBackgroundImage(UIImage(named: "btn_inappPlan_selected_monthly"), for: UIControl.State.normal)
                  let generator = UIImpactFeedbackGenerator(style: .heavy)
                  generator.impactOccurred()
                    
                    choosen = true
                   
                }else {
                   
                  isAnnualSelected = false
                   
                    monthlyPlanButton.setBackgroundImage(UIImage(named: "btn_monthly"), for: .normal)
                   
                  isMonthlySelected = true
                   
                    monthlyPlanButton.setBackgroundImage(UIImage(named: "btn_inappPlan_selected_monthly"), for: UIControl.State.normal)
                  let generator = UIImpactFeedbackGenerator(style: .heavy)
                  generator.impactOccurred()
                    
                    choosen = true
                }
                    // StoreKitOperations().purchaseProduct(productID : monthlyProductID, viewController : self)

              }
        

    @objc func annualPlanButtonClicked() {
                 
                 
                if isMonthlySelected {
                   
                  isMonthlySelected = false
                   
                    monthlyPlanButton.setBackgroundImage(UIImage(named: "btn_monthly"), for: UIControl.State.normal)
                   
                  isAnnualSelected = true
                    
                annualPlanButton.setBackgroundImage(UIImage(named: "btn_inappPlan_selected_annual"), for: .normal)
                  let generator = UIImpactFeedbackGenerator(style: .heavy)
                  generator.impactOccurred()
                    
                    choosen = true
                   
                }else{
                   
                  isMonthlySelected = false
                   
                    annualPlanButton.setBackgroundImage(UIImage(named: "btn_annual"), for: UIControl.State.normal)
                    
                  isAnnualSelected = true
                    annualPlanButton.setBackgroundImage(UIImage(named: "btn_inappPlan_selected_annual"), for: .normal)
                  let generator = UIImpactFeedbackGenerator(style: .heavy)
                  generator.impactOccurred()
                    
                    choosen = true
                }
               
              
       // StoreKitOperations().purchaseProduct(productID : annualProductID, viewController : self)

    }
    
    @objc func startButtonClicked()
    {
          
            
            if choosen == false {
                
                let alert = UIAlertController(title: "Choose a plan!", message: "You need to choose a plan to continue!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            
            } else if choosen {
                if isAnnualSelected == true {
                    
                    StoreKitOperations().purchaseProduct(productID : annualProductID, viewController : self)

                    
                }
                else if isMonthlySelected == true {
                    StoreKitOperations().purchaseProduct(productID : monthlyProductID, viewController : self)
                }
                    
                
            //    performSegue(withIdentifier: "inAppToMain", sender: nil)
            }
        }
        

        
        //        StoreKitOperations().purchaseProduct(productID : annualProductID, viewController : self)

    
}
