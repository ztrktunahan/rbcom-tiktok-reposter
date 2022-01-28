//
//  ModifiedBLTNItemManager.swift
//  HashtagsForInstagramSwift
//
//  Created by Влад Лыков on 04.02.2021.
//
/*
import UIKit
import BLTNBoard

class ModifiedBLTNItemManager: BLTNItemManager {

    public weak var delegate: BLTNDelegate?
    
    override func dismissBulletin(animated: Bool = true) {
        super.dismissBulletin(animated: animated)
        
        delegate?.bulletinViewDidDissmised()
        
    }
    
}

open class ModifiedBLTNInterfaceBuilder: BLTNInterfaceBuilder {
    
    open func makeTextField(placeholder: String? = nil,
                                  text: String? = nil,
                                  returnKey: UIReturnKeyType = .default,
                                  delegate: UITextFieldDelegate? = nil) -> UITextField {

        let textField = UITextField()
        
        if text != nil {
            textField.text = text
        } else {
            textField.placeholder = placeholder
        }
        
        textField.delegate = delegate
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.returnKeyType = returnKey

        return textField

    }
    
}


open class ModifiedBLTNActionItem: BLTNActionItem {
    
    func makeCustomContentViews(with interfaceBuilder: ModifiedBLTNInterfaceBuilder) -> [UIView] {
        return []
    }
    
}

open class ModifiedBLTNPageItem: BLTNPageItem {
    
    func makeCustomViewsUnderDescription(with interfaceBuilder: ModifiedBLTNInterfaceBuilder) -> [UIView]? {
        return nil
    }
    

    
}

public protocol BLTNDelegate: class {
    func bulletinViewDidDissmised()
}
*/
