import UIKit
import Dispatch
open class LRUnselectableTappableTextView: UITextView {
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
}
