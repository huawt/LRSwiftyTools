import UIKit
@objcMembers
open class LRGradientBorderView: UIView {
    @objc public var isGradientBorderEnable: Bool = false
    @objc @IBInspectable public var startColor: UIColor = UIColor.clear
    @objc @IBInspectable public var endColor: UIColor = UIColor.clear
    @objc @IBInspectable public var startPoint: CGPoint = CGPoint.zero
    @objc @IBInspectable public var endPoint: CGPoint = CGPoint.zero
    @objc @IBInspectable public var locations: CGPoint = CGPoint.zero
    @objc @IBInspectable public var gborderWidth: CGFloat = 0 {
        didSet {
            self.shapeLayer.borderWidth = gborderWidth
        }
    }
    @objc @IBInspectable public var gCornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    @objc public var customLocations: [NSNumber] = []
    @objc public var customColors: [UIColor] = []
    fileprivate var gradientLayer: CAGradientLayer = CAGradientLayer()
    fileprivate var shapeLayer: CAShapeLayer = CAShapeLayer()
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard self.isGradientBorderEnable else { return }
        self.layer.setNeedsDisplay()
    }
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        defer {
            self.gradientLayer.frame = self.bounds
            CATransaction.commit()
        }
        let newRect = CGRect(x: self.gborderWidth, y: self.gborderWidth, width: rect.width - 2 * self.gborderWidth, height: rect.height - 2 * self.gborderWidth)
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
