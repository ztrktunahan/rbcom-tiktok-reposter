//
//  AnimatedButton.swift
//  TimetableSwift
//
//  Created by Влад Лыков on 14.01.2021.
//

import UIKit

class AnimatedButton: UIButton {

    @IBInspectable var scaleIndex: Float = 0.94
    
    //MARK: Touches

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        checkStateChangedAndSendActions()
        
        if state == .highlighted {
            UIImpactFeedbackGenerator.tapticFeedback()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkStateChangedAndSendActions()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        checkStateChangedAndSendActions()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        checkStateChangedAndSendActions()
    }
    
    //MARK: Private Methods

    func checkStateChangedAndSendActions() {
        
        var transform: CGAffineTransform
        
        if  self.state == .highlighted {
            transform = CGAffineTransform(scaleX: CGFloat(scaleIndex), y: CGFloat(scaleIndex))
        } else {
            transform = .identity
        }
        
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseOut, .allowUserInteraction, .beginFromCurrentState],
                       animations: {
                        self.transform = transform
                       }, completion: nil)
        
    }
    
}
