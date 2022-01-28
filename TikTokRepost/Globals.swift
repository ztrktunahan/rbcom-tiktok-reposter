//
//  Globals.swift
//  Ultimate AdBlock
//
//  Created by Tuna Öztürk on 30.07.2021.
//

import Foundation
import UIKit
import Purchases
import Lottie

var isUserPremium = false

var uDefaults = UserDefaults.standard

var screenHeight = CGFloat()
var screenWidth = CGFloat()

func setDefaultSize(view : UIView){

    screenHeight = view.frame.size.height
    screenWidth = view.frame.size.width
}


let currency_symbol = Locale.current.currencySymbol!

func create_loading_view(view : UIView) -> UIView{
    
    let view_loading = UIView()
    view_loading.frame = view.bounds
    
    let view_background = UIView()
    view_background.frame = view_loading.bounds
    view_background.backgroundColor = .black
    view_background.alpha = 0.6
    view_loading.addSubview(view_background)
    
    let anim_loading = AnimationView(name: "animation")
    anim_loading.frame = CGRect(x: 0.25 * screenWidth, y: 0.25 * screenHeight, width: 0.5  * screenWidth, height: 0.5 * screenHeight)
    anim_loading.backgroundColor = .clear
    anim_loading.loopMode = .loop
    anim_loading.animationSpeed = 1
    anim_loading.backgroundBehavior = .pauseAndRestore
    view_loading.addSubview(anim_loading)
    anim_loading.play()
    
    return view_loading
    
}

func showAlert(title: String, message: String,  viewController : UIViewController){
    

    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
    
    
}

func vibrate(style : UIImpactFeedbackGenerator.FeedbackStyle){
    
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
    
}

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
