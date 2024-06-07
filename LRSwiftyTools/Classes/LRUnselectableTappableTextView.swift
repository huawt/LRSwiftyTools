import UIKit
import Dispatch
@objcMembers
open class LRUnselectableTappableTextView: UITextView, UITextViewDelegate {
    public var tappedHandler: ((_ tappedText: String)->Void)?
    @IBInspectable public var linkColor: UIColor? {
        didSet {
            guard let c = linkColor else { return }
            self.linkTextAttributes = [.foregroundColor: c, .underlineColor: c, .underlineStyle: NSUnderlineStyle.single.rawValue, .baselineOffset: 5]
        }
    }
    open override var selectedTextRange: UITextRange? {
        get { return nil }
        set {}
    }
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak gestureRecognizer] in
            gestureRecognizer?.isEnabled = true
        }
        if gestureRecognizer  is UIPanGestureRecognizer {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        if let tap = gestureRecognizer as? UITapGestureRecognizer, tap.numberOfTapsRequired == 1 {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        if let long = gestureRecognizer as? UILongPressGestureRecognizer, long.minimumPressDuration < 0.325 {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        gestureRecognizer.isEnabled = false
        return false
    }
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setup()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    private func setup() {
        self.delegate = self
        self.contentInsetAdjustmentBehavior = .never
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentInset = .zero
    }
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        self.tappedHandler?(URL.absoluteString)
        return false
    }
}
