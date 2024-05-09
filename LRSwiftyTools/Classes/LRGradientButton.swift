import Foundation
import UIKit
@objcMembers
open class LRGradientButton: UILayoutButton {
    @objc public var isGradientEnable: Bool = false
    @objc @IBInspectable public var isGradientEnableNumber: Int = 0 {
        didSet {
            self.isGradientEnable = isGradientEnableNumber > 0
        }
    }
    @objc @IBInspectable public var gStartColor: UIColor = UIColor.clear
    @objc @IBInspectable public var gEndColor: UIColor = UIColor.clear
    @objc @IBInspectable public var gStartPoint: CGPoint = CGPoint.zero
    @objc @IBInspectable public var gEndPoint: CGPoint = CGPoint.zero
    @objc @IBInspectable public var gLocations: CGPoint = CGPoint.zero
    @objc @IBInspectable public var gCornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.gradientLayer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    @objc public var customLocations: [NSNumber] = []
    @objc public var customColors: [UIColor] = []
    fileprivate var gradientLayer: CAGradientLayer = CAGradientLayer()
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.isHidden = !self.isGradientEnable
        guard self.isGradientEnable else { return }
        self.configGradientLayer()
    }
    private func configGradientLayer() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        defer {
            self.gradientLayer.frame = self.bounds
            self.layer.insertSublayer(self.gradientLayer, at: 0)
            CATransaction.commit()
        }
        if self.customColors.isEmpty == false {
            self.gradientLayer.colors = self.customColors.compactMap({ $0.cgColor })
            self.gradientLayer.locations = self.customLocations
        } else {
            self.gradientLayer.colors = [gStartColor.cgColor, gEndColor.cgColor]
            self.gradientLayer.locations = [NSNumber(value: self.gLocations.x), NSNumber(value: self.gLocations.y)]
        }
        self.gradientLayer.startPoint = self.gStartPoint
        self.gradientLayer.endPoint = self.gEndPoint;
    }
}
