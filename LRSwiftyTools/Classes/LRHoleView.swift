import UIKit
import Foundation
public struct LRHoleConfig {
    var rect: CGRect
    var corners: UIRectCorner
    var cornerRadii: CGSize
    var fillColor: UIColor
    var strokeColor: UIColor
    
    public init(rect: CGRect, corners: UIRectCorner, cornerRadii: CGSize, fillColor: UIColor, strokeColor: UIColor) {
        self.rect = rect
        self.corners = corners
        self.cornerRadii = cornerRadii
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }
}
@objcMembers
open class LRHoleView: UIView {
    private lazy var shapeLayer = CAShapeLayer()
    public var config: LRHoleConfig = LRHoleConfig(rect: .zero, corners: [.allCorners], cornerRadii: .zero, fillColor: .clear, strokeColor: .clear) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        let allPath = UIBezierPath(rect: rect)
        let maskPath = UIBezierPath(roundedRect: self.config.rect, byRoundingCorners: self.config.corners, cornerRadii: self.config.cornerRadii)
        allPath.append(maskPath)
        allPath.usesEvenOddFillRule = true
        shapeLayer.path = allPath.cgPath
        shapeLayer.frame = CGRect(origin: .zero, size: rect.size)
        shapeLayer.fillColor = self.config.strokeColor.cgColor
        shapeLayer.fillRule = .evenOdd
        self.layer.backgroundColor = self.config.fillColor.cgColor
        guard shapeLayer.superlayer == nil else { return }
        self.layer.addSublayer(shapeLayer)
    }
}
