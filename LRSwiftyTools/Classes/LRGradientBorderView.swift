//
//  LRGradientBorderView.swift
//  
//
//  Created by huawt on 2022/5/9.
//

import UIKit

class LRGradientBorderView: UIView {
    var isGradientBorderEnable: Bool = false
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear
    @IBInspectable var startPoint: CGPoint = CGPoint.zero
    @IBInspectable var endPoint: CGPoint = CGPoint.zero
    @IBInspectable var locations: CGPoint = CGPoint.zero
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.shapeLayer.borderWidth = borderWidth
        }
    }
    @IBInspectable var gCornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    var customLocations: [NSNumber] = []
    var customColors: [UIColor] = []
    
    fileprivate var gradientLayer: CAGradientLayer = CAGradientLayer()
    fileprivate var shapeLayer: CAShapeLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.isGradientBorderEnable else { return }
        self.layer.setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        defer {
            self.gradientLayer.frame = self.bounds
            CATransaction.commit()
        }
        let newRect = CGRect(x: self.borderWidth, y: self.borderWidth, width: rect.width - 2 * self.borderWidth, height: rect.height - 2 * self.borderWidth)
        if self.customColors.isEmpty == false {
            self.gradientLayer.colors = self.customColors.compactMap({ $0.cgColor })
            self.gradientLayer.locations = self.customLocations
        } else {
            self.gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            self.gradientLayer.locations = [NSNumber(value: self.locations.x), NSNumber(value: self.locations.y)]
        }
        self.gradientLayer.startPoint = self.startPoint
        self.gradientLayer.endPoint = self.endPoint;
        self.shapeLayer.path = UIBezierPath(roundedRect: newRect, cornerRadius: self.gCornerRadius).cgPath
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        self.shapeLayer.strokeColor = UIColor.white.cgColor
        self.gradientLayer.mask = self.shapeLayer
        if self.gradientLayer.superlayer == nil {
            self.layer.insertSublayer(self.gradientLayer, at: 0)
        }
    }
}
