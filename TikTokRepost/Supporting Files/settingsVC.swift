//
//  settingsVC.swift
//  TikTokRepost
//
//  Created by ege on 14.09.2021.
//
import StoreKit
import UIKit
import MessageUI
import Hero

class settingsVC: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        let stringMultiplier = 0.00115 * screenHeight
        
        
        view.backgroundColor = .white
        
        let backgroundView = UIView()
        //backgroundView.frame =  CGRect(x: 0 * screenWidth, y: 0 * screenHeight, width: 414 * screenWidth, height: 0.130 * screenHeight)
        backgroundView.backgroundColor = UIColor(red: 0.24, green: 0.15, blue: 0.24, alpha: 1.00)
        backgroundView.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 1.4
        backgroundView.frame = CGRect(x: 0 * screenWidth, y: 0 * screenHeight, width: 1 * screenWidth, height: 0.130 * screenHeight)
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.masksToBounds = true
        view.addSubview(backgroundView)
        
        let settingsTitle = UILabel()
        settingsTitle.textColor = .white
        settingsTitle.text = NSLocalizedString("Settings", comment: "")
        settingsTitle.textAlignment = .center
        settingsTitle.font = UIFont(name: "AvenirNext-Bold", size: 22 * stringMultiplier)
        settingsTitle.frame = CGRect(x: 0.05 * screenWidth, y: 0.07 * screenHeight, width: 0.9 * screenWidth, height: 0.046 * screenHeight)
        view.addSubview(settingsTitle)
        
        let backButton = UIButton()
        backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        backButton.setBackgroundImage(UIImage(named: "btn_back"), for: UIControl.State.normal)
        backButton.frame = CGRect(x: 0.09 * screenWidth, y: 0.075 * screenHeight, width: 0.040 * screenWidth, height: 0.030 * screenHeight)
        backButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        backButton.layer.shadowRadius = 5
        backButton.layer.shadowOpacity = 1.4
        backButton.contentVerticalAlignment.self = .center
        backButton.contentHorizontalAlignment.self = .center
        view.addSubview(backButton)
        
        backButton.addTarget(self, action: #selector(backButtonClicked), for: UIControl.Event.touchUpInside)

        //Get Premium
        
        let premiumButton = UIButton()
        premiumButton.setBackgroundImage(UIImage(named: "btn_getpremium"), for: UIControl.State.normal)
        premiumButton.frame = CGRect(x: 0 * screenWidth, y: 0.223 * screenHeight, width: 0.999 * screenWidth, height: 0.13 * screenHeight)
        premiumButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        premiumButton.layer.shadowRadius = 5
        premiumButton.layer.shadowOpacity = 1.4
        view.addSubview(premiumButton)
        premiumButton.addTarget(self, action: #selector(premiumButtonClicked), for: UIControl.Event.touchUpInside)
        
        let getPremiumLabel = UILabel ()
        getPremiumLabel.text = NSLocalizedString("Get Premium", comment: "")
        getPremiumLabel.textAlignment = .left
        getPremiumLabel.textColor = .black
        getPremiumLabel.font = UIFont(name: "Poppins-Regular", size: 16 * stringMultiplier)
        getPremiumLabel.frame = CGRect (x: 0.3 * screenWidth, y: 0.223 * screenHeight, width: 0.4 * screenWidth, height: 0.13 * screenHeight)
        view.addSubview(getPremiumLabel)
        
        
        
        
        
        // Rate Us
        let rateUsButton = UIButton()
        rateUsButton.setBackgroundImage(UIImage(named: "btn_rateus"), for: UIControl.State.normal)
        rateUsButton.frame = CGRect(x: 0 * screenWidth, y: 0.331 * screenHeight, width: 0.999 * screenWidth, height: 0.13 * screenHeight)
        rateUsButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        rateUsButton.layer.shadowRadius = 5
        rateUsButton.layer.shadowOpacity = 1.4
        view.addSubview(rateUsButton)
        rateUsButton.addTarget(self, action: #selector(rateUsButtonClicked), for: UIControl.Event.touchUpInside)
        
        
        let rateUsLabel = UILabel ()
        rateUsLabel.text = NSLocalizedString("Rate Us", comment: "")
        rateUsLabel.textAlignment = .left
        rateUsLabel.textColor = .black
        rateUsLabel.font = UIFont(name: "Poppins-Regular", size: 16 * stringMultiplier)
        rateUsLabel.frame = CGRect (x: 0.3 * screenWidth, y: 0.331 * screenHeight, width: 0.4 * screenWidth, height: 0.13 * screenHeight)
        view.addSubview(rateUsLabel)
        
        
        
        
        // Contact Us
        let contactUsButton = UIButton()
        contactUsButton.setBackgroundImage(UIImage(named: "btn_contactus"), for: UIControl.State.normal)
        contactUsButton.frame = CGRect(x: 0 * screenWidth, y: 0.439 * screenHeight, width: 0.999 * screenWidth, height: 0.13 * screenHeight)
        contactUsButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        contactUsButton.layer.shadowRadius = 5
        contactUsButton.layer.shadowOpacity = 1.4
        view.addSubview(contactUsButton)
        contactUsButton.addTarget(self, action: #selector(contactUsButtonClicked), for: UIControl.Event.touchUpInside)
        
        
        let contactUsLabel = UILabel ()
        contactUsLabel.text = NSLocalizedString("Contact Us", comment: "")
        contactUsLabel.textAlignment = .left
        contactUsLabel.textColor = .black
        contactUsLabel.font = UIFont(name: "Poppins-Regular", size: 16 * stringMultiplier)
        contactUsLabel.frame = CGRect (x: 0.3 * screenWidth, y: 0.439 * screenHeight, width: 0.4 * screenWidth, height: 0.13 * screenHeight)
        view.addSubview(contactUsLabel)
        
        
        
        
        //Privacy Policy
        let privacyButton = UIButton()
        privacyButton.setBackgroundImage(UIImage(named: "btn_privacypolicy"), for: UIControl.State.normal)
        privacyButton.frame = CGRect(x: 0 * screenWidth, y: 0.547 * screenHeight, width: 0.999 * screenWidth, height: 0.13 * screenHeight)
        privacyButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        privacyButton.layer.shadowRadius = 5
        privacyButton.layer.shadowOpacity = 1.4
        view.addSubview(privacyButton)
        privacyButton.addTarget(self, action: #selector(privacyButtonClicked), for: UIControl.Event.touchUpInside)
        
        let privacyLabel = UILabel ()
        privacyLabel.text = NSLocalizedString("Privacy Policy", comment: "")
        privacyLabel.textAlignment = .left
        privacyLabel.textColor = .black
        privacyLabel.font = UIFont(name: "Poppins-Regular", size: 16 * stringMultiplier)
        privacyLabel.frame = CGRect (x: 0.3 * screenWidth, y: 0.547 * screenHeight, width: 0.4 * screenWidth, height: 0.13 * screenHeight)
        view.addSubview(privacyLabel)
        
        
        
        //Terms of Use
        
        let termsButton = UIButton()
        termsButton.setBackgroundImage(UIImage(named: "btn_termsofuse"), for: UIControl.State.normal)
        termsButton.frame = CGRect(x: 0 * screenWidth, y: 0.655 * screenHeight, width: 0.999 * screenWidth, height: 0.13 * screenHeight)
        termsButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        termsButton.layer.shadowRadius = 5
        termsButton.layer.shadowOpacity = 1.4
        view.addSubview(termsButton)
        termsButton.addTarget(self, action: #selector(termsButtonClicked), for: UIControl.Event.touchUpInside)
           
    
    let termsOfLabel = UILabel ()
        termsOfLabel.text = NSLocalizedString("Terms of Use", comment: "")
        termsOfLabel.textAlignment = .left
        termsOfLabel.textColor = .black
        termsOfLabel.font = UIFont(name: "Poppins-Regular", size: 16 * stringMultiplier)
        termsOfLabel.frame = CGRect (x: 0.3 * screenWidth, y: 0.655 * screenHeight, width: 0.4 * screenWidth, height: 0.13 * screenHeight)
    view.addSubview(termsOfLabel)
    
    
    }
    @objc func premiumButtonClicked() {
        performSegue(withIdentifier: "toinApp", sender: nil)
        
        
}
    
    @objc func backButtonClicked() {
        
        dismiss(animated: true, completion: nil)
        
}
    @objc func rateUsButtonClicked() {
        
        SKStoreReviewController.requestReview()

        
}
    @objc func contactUsButtonClicked() {
        
        sendEmail()

}
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["appforce77@gmail.com"])


            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    @objc func privacyButtonClicked() {
        
        if let url = URL(string: "https://www.appforce.xyz/privacy-policy-tik-saver") {
              if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
              }
        
        }
}
        @objc func termsButtonClicked() {
        if let url = URL(string: "https://www.appforce.xyz/terms-and-conditions-tik-saver") {
              if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
              }
            }
}


}
