import Foundation
import UIKit
import QuartzCore
let kLabelCount: Int = 2
let kDefaultFadeLength: CGFloat = 7
let kDefaultLabelBufferSpace: Int = 20
let kDefaultPixelsPerSecond: CGFloat = 30
let kDefaultPauseTime: CGFloat = 1.5
@objc public enum LRAutoScrollDirection: Int {
    case right
    case left
}
@objcMembers
open class LRAutoScrollLabel: UIView, UIScrollViewDelegate {
    @objc public var scrollDirection: LRAutoScrollDirection = .left {
        didSet {
            self.scrollLabelIfNeeded()
        }
    }
    @objc public var scrollSpeed: CGFloat = kDefaultPixelsPerSecond {
        didSet {
            self.scrollLabelIfNeeded()
        }
    }
    @objc public var pauseInterval: TimeInterval = kDefaultPauseTime
    @objc public var labelSpacing: Int = kDefaultLabelBufferSpace
    @objc public var animationOptions: UIView.AnimationOptions = .curveLinear
    public private(set) var scrolling: Bool = false
    @objc public var fadeLength: CGFloat = kDefaultFadeLength {
        willSet {
            if fadeLength == newValue { return }
        }
        didSet {
            self.refreshLabels()
            self.applyGradientMask(for: fadeLength, enable: false)
        }
    }
    @objc public var font: UIFont {
        set {
            guard font != newValue else { return }
            self.labels.forEach { label in
                label.font = newValue
            }
            self.refreshLabels()
            self.invalidateIntrinsicContentSize()
        }
        get {
            return self.mainLabel.font
        }
    }
    @objc public var text: String? {
        set {
            guard text != newValue else { return }
            self.setText(newValue, refreshLabels: true)
        }
        get {
            return self.mainLabel.text
        }
    }
    @objc public var attributedText: NSAttributedString? {
        set {
            guard attributedText?.string != newValue?.string else { return }
            self.setAttributedText(newValue, refreshLabels: true)
        }
        get {
            return self.mainLabel.attributedText
        }
    }
    @objc public var textColor: UIColor {
        set {
            guard textColor != newValue else { return }
            self.labels.forEach { label in
                label.textColor = newValue
            }
        }
        get {
            self.mainLabel.textColor
        }
    }
    @objc public var textAlignment: NSTextAlignment = .left
    @objc public var shadowColor: UIColor? {
        set {
            self.labels.forEach { label in
                label.shadowColor = newValue
            }
        }
        get {
            return self.mainLabel.shadowColor
        }
    }
    @objc public var shadowOffset: CGSize {
        set {
            self.labels.forEach { label in
                label.shadowOffset = newValue
            }
        }
        get {
            return self.mainLabel.shadowOffset
        }
    }
    fileprivate var labels: [UILabel] = []
    fileprivate var mainLabel: UILabel {
        return self.labels.first ?? UILabel()
    }
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.bounds)
        scroll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scroll.backgroundColor = .clear
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.isScrollEnabled = false
        return scroll
    }()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    fileprivate func commonInit() {
        self.addSubview(self.scrollView)
        for _ in 0 ..< 2 {
            let label = UILabel()
            label.backgroundColor = .clear
            label.autoresizingMask = self.autoresizingMask
            self.scrollView.addSubview(label)
            self.labels.append(label)
        }
        self.isUserInteractionEnabled = false
        self.backgroundColor = .clear
        self.clipsToBounds = true
    }
    deinit {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        NotificationCenter.default.removeObserver(self)
    }
    open override var frame: CGRect {
        didSet {
            self.didChangeFrame()
        }
    }
    open override var bounds: CGRect {
        didSet {
            self.didChangeFrame()
        }
    }
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        if self.window != nil {
            self.scrollLabelIfNeeded()
        }
    }
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: self.mainLabel.intrinsicContentSize.height)
    }
    fileprivate func didChangeFrame() {
        self.refreshLabels()
        self.applyGradientMask(for: self.fadeLength, enable: self.scrolling)
    }
    fileprivate func applyGradientMask(for fadeLength: CGFloat, enable fade: Bool) {
        var fadeLength = fadeLength
        let labelWidth = self.mainLabel.bounds.width
        if labelWidth <= self.bounds.width { fadeLength = 0 }
        if fadeLength > 0 {
            let gradientMask = CAGradientLayer()
            gradientMask.bounds = self.layer.bounds
            gradientMask.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            gradientMask.shouldRasterize = true
            gradientMask.rasterizationScale = UIScreen.main.scale
            gradientMask.startPoint = CGPoint(x: 0, y: self.frame.midY)
            gradientMask.endPoint = CGPoint(x: 1, y: self.frame.midY)
            let transparent = UIColor.clear.cgColor
            let opaque = UIColor.black.cgColor
            gradientMask.colors = [transparent, opaque, opaque, transparent]
            let fadePoint = fadeLength / self.bounds.width
            var leftFadePoint = NSNumber(value: fadePoint)
            var rightFadePoint = NSNumber(value: 1 - fadePoint)
            if fade == false {
                switch self.scrollDirection {
                case .left:
                    leftFadePoint = 0
                case .right:
                    leftFadePoint = 0
                    rightFadePoint = 1
                }
            }
            gradientMask.locations = [0, leftFadePoint, rightFadePoint, 1]
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.layer.mask = gradientMask
            CATransaction.commit()
        } else {
            self.layer.mask = nil
        }
    }
    public func refreshLabels() {
        var offset: CGFloat = 0
        self.labels.forEach { label in
            label.sizeToFit()
            var frame = label.frame
            frame.origin = CGPoint(x: offset, y: 0)
            frame.size.height = self.bounds.height
            label.frame = frame
            label.center = CGPoint(x: label.center.x, y: round(self.center.y - self.frame.minY))
            offset = offset + label.bounds.width + CGFloat(self.labelSpacing)
        }
        self.scrollView.contentOffset = .zero
        self.scrollView.layer.removeAllAnimations()
        if self.mainLabel.bounds.width > self.bounds.width {
            var size: CGSize = .zero
            size.width = self.mainLabel.bounds.width + self.bounds.width + CGFloat(self.labelSpacing)
            size.height = self.bounds.height
            self.scrollView.contentSize = size
            self.labels.forEach({ $0.isHidden = false })
            self.applyGradientMask(for: self.fadeLength, enable: self.scrolling)
            self.scrollLabelIfNeeded()
        } else {
            self.labels.forEach({ $0.isHidden = self.mainLabel != $0 })
            self.scrollView.contentSize = self.bounds.size
            self.mainLabel.frame = self.bounds
            self.mainLabel.isHidden = false
            self.mainLabel.textAlignment = self.textAlignment
            self.scrollView.layer.removeAllAnimations()
            self.applyGradientMask(for: 0, enable: false)
        }
    }
    public func setText(_ text: String?, refreshLabels: Bool) {
        self.labels.forEach { label in
            label.text = text
        }
        if refreshLabels {
            self.refreshLabels()
        }
    }
    public func setAttributedText(_ theText: NSAttributedString?, refreshLabels: Bool) {
        self.labels.forEach { label in
            label.attributedText = theText
        }
        if refreshLabels {
            self.refreshLabels()
        }
    }
    @objc public func scrollLabelIfNeeded() {
        guard self.text?.isEmpty == false else { return }
        let labelWidth = self.mainLabel.bounds.width
        guard labelWidth > self.bounds.width else { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(scrollLabelIfNeeded), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(enableShadow), object: nil)
        self.scrollView.layer.removeAllAnimations()
        let doScrollLeft: Bool = self.scrollDirection == .left
        self.scrollView.contentOffset = doScrollLeft ? .zero : CGPoint(x: Int(labelWidth) + self.labelSpacing, y: 0)
        self.perform(#selector(enableShadow), with: nil, afterDelay: self.pauseInterval)
        let duration: TimeInterval = labelWidth / self.scrollSpeed
        UIView.animate(withDuration: duration, delay: self.pauseInterval, options: [self.animationOptions, .allowUserInteraction]) {
            self.scrollView.contentOffset = doScrollLeft ? CGPoint(x: Int(labelWidth) + self.labelSpacing, y: 0) : .zero
        } completion: { finish in
            self.scrolling = false
            self.applyGradientMask(for: self.fadeLength, enable: false)
            if finish {
                self.perform(#selector(self.scrollLabelIfNeeded))
            }
        }
    }
    public func observeApplicationNotifications() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollLabelIfNeeded), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollLabelIfNeeded), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    @objc fileprivate func enableShadow() {
        self.scrolling = true
        self.applyGradientMask(for: self.fadeLength, enable: true)
    }
}
