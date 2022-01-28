//
//  PlusButton.swift
//  TimetableSwift
//
//  Created by Влад Лыков on 13.01.2021.
//

import UIKit

class PlusButton: AnimatedButton {
    
    @IBInspectable var elementColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var mainColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var tintColor: UIColor? {
        didSet {
            mainColor = tintColor
        }
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(mainColor.cgColor)

        let minSize = min(rect.size.width, rect.size.height)

        let customRect = CGRect(x: rect.midX - minSize/2,
                                y: rect.midY - minSize/2,
                                width:  minSize,
                                height: minSize)

        context?.addEllipse(in: customRect)

        context?.fillPath()

        let offset = Int(customRect.width / 3.3)

        context?.move   (to: CGPoint(x: customRect.midX, y: customRect.minY + CGFloat(offset)))
        context?.addLine(to: CGPoint(x: customRect.midX, y: customRect.maxY - CGFloat(offset)))

        context?.move   (to: CGPoint(x: customRect.minX + CGFloat(offset), y: customRect.midY))
        context?.addLine(to: CGPoint(x: customRect.maxX - CGFloat(offset), y: customRect.midY))

        context?.setStrokeColor(elementColor.cgColor)

        context?.setLineCap(.round)
        context?.setLineWidth(CGFloat(min(Int(customRect.height / 10.0), Int(customRect.width / 10.0))))

        context?.strokePath()
    
        layer.shadowColor = mainColor.cgColor
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        clipsToBounds = false
        
    }

}
