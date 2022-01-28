//
//  onBoarding3VC.swift
//  TikTokRepost
//
//  Created by ege on 13.09.2021.
//

import UIKit
import Hero

class onBoarding3VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        let stringMultiplier = 0.00115 * screenHeight
        
        uDefaults.setValue(true, forKey: "userFirst")
        
        
        view.backgroundColor = .white
        
        let onboardingHeadImage = UIImageView ()
        onboardingHeadImage.image = UIImage (named: "img_onboarding_3")
        onboardingHeadImage.frame = CGRect(x: 0.2 * screenWidth, y: 0.15 * screenHeight, width: 0.6 * screenWidth, height: 0.3 * screenHeight)
        view.addSubview(onboardingHeadImage)
        
        let onboardingBackground = UIImageView()
        onboardingBackground.image = UIImage(named: "img_onboarding_front_3")
        onboardingBackground.frame = CGRect(x: 0 * screenWidth, y: 0.5 * screenHeight, width: 0.999 * screenWidth, height: 0.4 * screenHeight)
        view.addSubview(onboardingBackground)
     
        let title = UILabel()
        title.textColor = UIColor(red:0.00, green:0.02, blue:0.26, alpha:1.0)
        title.text = NSLocalizedString("Share In One Tap", comment: "")
        title.textAlignment = .center
        title.font = UIFont(name: "Poppins-Bold", size: 22 * stringMultiplier)
        title.frame = CGRect(x: 0.145 * screenWidth, y: 0.6 * screenHeight, width: 0.737 * screenWidth, height: 0.060 * screenHeight)
        view.addSubview(title)

        
        let subtitle = UILabel()
        subtitle.textColor = UIColor(red:0.00, green:0.02, blue:0.26, alpha:1.0)
        subtitle.text = NSLocalizedString("Watch the preview of the video you want to repost, then just tap share and share!", comment: "")
        subtitle.textAlignment = .center
        subtitle.font = UIFont(name: "Poppins-Regular", size: 18 * stringMultiplier)
        subtitle.frame = CGRect(x: 0.1 * screenWidth, y: 0.662 * screenHeight, width: 0.8 * screenWidth, height: 0.134 * screenHeight)
        subtitle.numberOfLines = 4
        view.addSubview(subtitle)
        
        let pagePointIcon = UIImageView ()
        pagePointIcon.image = UIImage (named: "img_slider_3")
        pagePointIcon.frame = CGRect(x: 0.420 * screenWidth, y: 0.83 * screenHeight, width: 0.135 * screenWidth, height: 0.017 * screenHeight)
        view.addSubview(pagePointIcon)
        
        
        let nextButton = UIButton()
        nextButton.setTitle(NSLocalizedString("Next", comment: ""), for: UIControl.State.normal)
        nextButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        nextButton.setBackgroundImage(UIImage(named: "btn_onboarding_next"), for: UIControl.State.normal)
        nextButton.frame = CGRect(x: 0.05 * screenWidth, y: 0.84 * screenHeight, width: 0.9 * screenWidth, height: 0.150 * screenHeight)
        nextButton.contentVerticalAlignment.self = .center
        nextButton.contentHorizontalAlignment.self = .center
        nextButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 20 * stringMultiplier)
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: UIControl.Event.touchUpInside)
        
        
    }
    
    @objc func nextButtonClicked() {
        performSegue(withIdentifier: "onBoarding3toinApp", sender: nil)
        
        
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "onBoarding3toinApp"{
        let destination = segue.destination as! inAppVC
        destination.hero.isEnabled = true
        destination.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))
      }
}
}
