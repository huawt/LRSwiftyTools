import UIKit
private let SectionBackground = "LRCollectionReusableView"
@objcMembers
open class LRLayerAppearance: NSObject {
    public static func < (lhs: LRLayerAppearance, rhs: LRLayerAppearance) -> Bool {
        return true
    }
    public override init() { }
    public var shadowColor: UIColor = .clear
    public var shadowOffset: CGSize = .zero
    public var shadowOpacity: Float = 0
    public var shadowRadius: CGFloat = 0
    public var cornerRadius: CGFloat = 0
    public static func == (lhs: LRLayerAppearance, rhs: LRLayerAppearance) -> Bool {
        return lhs.shadowColor.isEqual(rhs.shadowColor) && lhs.shadowOffset.equalTo(rhs.shadowOffset) && lhs.shadowOpacity == rhs.shadowOpacity && lhs.shadowRadius == rhs.shadowRadius && lhs.cornerRadius == rhs.cornerRadius
    }
}
@objc public protocol LRCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, containerColorForSectionAt section: Int) -> UIColor
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, subColorForSectionAt section: Int) -> UIColor
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, layerAppearanceForSectionAt section: Int) -> LRLayerAppearance
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, containerInsetForSectionAt section: Int) -> UIEdgeInsets
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, subInsetForSectionAt section: Int) -> UIEdgeInsets
}
private class LRCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor: UIColor = UIColor.clear
    var containerColor: UIColor = .clear
    var subColor: UIColor = .clear
    var appearance: LRLayerAppearance = LRLayerAppearance()
    var edgeInsets: UIEdgeInsets = .zero
    var subInsets: UIEdgeInsets = .zero
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! LRCollectionViewLayoutAttributes
        copy.backgroundColor = self.backgroundColor
        copy.containerColor = self.containerColor
        copy.subColor = self.subColor
        copy.appearance = self.appearance
        copy.edgeInsets = self.edgeInsets
        copy.subInsets = self.subInsets
        return copy
    }
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? LRCollectionViewLayoutAttributes else {
            return false
        }
        if !self.backgroundColor.isEqual(rhs.backgroundColor) ||  !self.containerColor.isEqual(rhs.containerColor) || !self.subColor.isEqual(rhs.subColor) || self.appearance != rhs.appearance || self.edgeInsets != rhs.edgeInsets || self.subInsets != rhs.subInsets {
            return false
        }
        return super.isEqual(object)
    }
}
private class LRCollectionReusableView: UICollectionReusableView {
    private lazy var containerView: UIView = UIView()
    private lazy var subView: UIView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.subView)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attr = layoutAttributes as? LRCollectionViewLayoutAttributes else {
            return
        }
        self.backgroundColor = attr.backgroundColor
        self.containerView.backgroundColor = attr.containerColor
        self.subView.backgroundColor = attr.subColor
        let edgeInsets = attr.edgeInsets
        self.containerView.frame = CGRect(x: edgeInsets.left, y: edgeInsets.top, width: self.frame.width - edgeInsets.left - edgeInsets.right, height: self.frame.height - edgeInsets.top - edgeInsets.bottom)
        let subInsets = attr.subInsets
        self.subView.frame = CGRect(x: subInsets.left, y: subInsets.top, width: self.containerView.frame.width - subInsets.left - subInsets.right, height: self.containerView.frame.height - subInsets.top - subInsets.bottom)
        self.containerView.layer.shadowColor = attr.appearance.shadowColor.cgColor
        self.containerView.layer.shadowRadius = attr.appearance.shadowRadius
        self.containerView.layer.shadowOffset = attr.appearance.shadowOffset
        self.containerView.layer.shadowOpacity = attr.appearance.shadowOpacity
        self.containerView.layer.cornerRadius = attr.appearance.cornerRadius
    }
}
@objcMembers
open class LRCollectionColorFlowLayout: UICollectionViewFlowLayout {
    private var decorationViewAttrs: [UICollectionViewLayoutAttributes] = []
    public override init() {
        super.init()
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    func setup() {
        self.register(LRCollectionReusableView.classForCoder(), forDecorationViewOfKind: SectionBackground)
    }
    public override func prepare() {
        super.prepare()
        guard let numberOfSections = self.collectionView?.numberOfSections,
            let delegate = self.collectionView?.delegate as? LRCollectionViewDelegateFlowLayout
            else {
                return
        }
        self.decorationViewAttrs.removeAll()
        for section in 0..<numberOfSections {
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),
                numberOfItems > 0,
                let firstItem = self.layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at: IndexPath(item: numberOfItems - 1, section: section)) else {
                    continue
            }
            var sectionInset = self.sectionInset
            if let inset = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            sectionFrame.origin.x = 0
            sectionFrame.origin.y -= sectionInset.top
            if self.scrollDirection == .horizontal {
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = self.collectionView!.frame.height
            } else {
                sectionFrame.size.width = self.collectionView!.frame.width
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }
            if let size = delegate.collectionView?(self.collectionView!, layout: self, referenceSizeForHeaderInSection: section), size.height > 0 {
                sectionFrame.origin.y -= size.height
                if self.scrollDirection == .horizontal {
                    sectionFrame.size.width += size.width
                } else {
                    sectionFrame.size.height += size.height
                }
            }
            let attr = LRCollectionViewLayoutAttributes(forDecorationViewOfKind: SectionBackground, with: IndexPath(item: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            attr.backgroundColor = delegate.collectionView?(self.collectionView!, layout: self, backgroundColorForSectionAt: section) ?? UIColor.clear
            attr.containerColor = delegate.collectionView?(self.collectionView!, layout: self, containerColorForSectionAt: section) ?? UIColor.clear
            attr.subColor = delegate.collectionView?(self.collectionView!, layout: self, subColorForSectionAt: section) ?? UIColor.clear
            attr.appearance = delegate.collectionView?(self.collectionView!, layout: self, layerAppearanceForSectionAt: section) ?? LRLayerAppearance()
            attr.edgeInsets = delegate.collectionView?(self.collectionView!, layout: self, containerInsetForSectionAt: section) ?? .zero
            attr.subInsets = delegate.collectionView?(self.collectionView!, layout: self, subInsetForSectionAt: section) ?? .zero
            self.decorationViewAttrs.append(attr)
        }
    }
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = super.layoutAttributesForElements(in: rect)
        attrs?.append(contentsOf: self.decorationViewAttrs.filter {
            return rect.intersects($0.frame)
        })
        return attrs
    }
    public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == SectionBackground {
            return self.decorationViewAttrs[indexPath.section]
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
}
