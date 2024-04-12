import UIKit
@objcMembers
open class LRTextView: UITextView {
    private lazy var placeholderLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.lightGray
        l.backgroundColor = UIColor.clear
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 14)
        l.alpha = 0
        return l
    }()
    @objc @IBInspectable public var placeholder: String = "" {
        didSet {
            self.placeholderLabel.text = placeholder
            self.placeholderLabel.sizeToFit()
        }
    }
    @objc @IBInspectable public var placeholderColor: UIColor = .clear {
        didSet {
            self.placeholderLabel.textColor = placeholderColor
            self.placeholderLabel.sizeToFit()
        }
    }
    open override var font: UIFont? {
        didSet {
            self.placeholderLabel.font = font
            self.placeholderLabel.sizeToFit()
        }
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.addObserver()
        self.setup()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addObserver()
        self.setup()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.addObserver()
        self.setup()
    }
    private func setup() {
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.frame = CGRect(x: self.contentInset.left + 5, y: self.contentInset.top + 8, width: self.placeholderLabel.bounds.width, height: self.placeholderLabel.bounds.height)
    }
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    @objc private func textViewDidChanged() {
        self.placeholderLabel.alpha = self.hasText ? 0 : 1
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.placeholderLabel.alpha = self.hasText ? 0 : 1
    }
}
