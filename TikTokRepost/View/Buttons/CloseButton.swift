//
//  CloseButton.swift
//  TimetableSwift
//
//  Created by Влад Лыков on 13.01.2021.
//

import UIKit

class CloseButton: UIButton {
    
    @IBInspectable var elementColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var mainColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            elementColor = elementColor.withAlphaComponent(isHighlighted ? 0.1 : 0.6)
            setNeedsDisplay()
        }
    }
        
    override func draw(_ rect: CGRect) {
    
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(mainColor.cgColor)
    
        let minSize = min(rect.size.width, rect.size.height)
        
        let customRect = CGRect(x: rect.midX - minSize/2,
                                y: rect.midY - minSize/2,
                                width:  minSize,
                                height: minSize)
        
        context?.addEllipse(in: customRect)
    
        context?.fillPath()
    
        let offset = Int(customRect.width / 3)
    
        context?.move   (to: CGPoint(x: customRect.minX + CGFloat(offset),
                                     y: customRect.minY + CGFloat(offset)))
        context?.addLine(to: CGPoint(x: customRect.maxX - CGFloat(offset),
                                     y: customRect.maxY - CGFloat(offset)))
    
        context?.move   (to: CGPoint(x: customRect.maxX - CGFloat(offset),
                                     y: customRect.minY + CGFloat(offset)))
        context?.addLine(to: CGPoint(x: customRect.minX + CGFloat(offset),
                                     y: customRect.maxY - CGFloat(offset)))
        
        context?.setStrokeColor(elementColor.cgColor)
    
        context?.setLineCap(.round)
        context?.setLineWidth(CGFloat(min(Int(customRect.height / 10.0), Int(customRect.width / 10.0))))
    
        context?.strokePath()
    
    }
    
}
