
import Foundation
public extension String {
	func height(for font: UIFont, constrainedTo width: CGFloat) -> CGFloat {
		return self.boundingSize(for: font, constrainedWidth: width).height
	}

	func width(for font: UIFont, constrainedHeight height: CGFloat) -> CGFloat {
		return self.boundingSize(for: font, constrainedHeight: height).width
	}

	func boundingSize(for font: UIFont, constrainedWidth width: CGFloat) -> CGSize {
		let constrainedSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
		return self.boundingRect(for: font, constrained: constrainedSize).size
	}

	func boundingSize(for font: UIFont, constrainedHeight height: CGFloat) -> CGSize {
		let constrainedSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
		return self.boundingRect(for: font, constrained: constrainedSize).size
	}

	func boundingRect(for font: UIFont, constrained size: CGSize) -> CGRect {
		let paragraph = NSMutableParagraphStyle()
		paragraph.lineBreakMode = .byWordWrapping

		let attributes = [
			NSAttributedString.Key.font: font,
			NSAttributedString.Key.paragraphStyle: paragraph
		]
		return self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: attributes, context: nil)
	}

	// 字符串截取，传入需要截取的字符串开始位置(不按索引算)、结束位置(包含)
	func subString(from: Int, to: Int) -> String {
		if from < 0 { return "" } // 非法起点
		if count < to { return "" } // 避免下标越界

		let startIndex = self.index(self.startIndex, offsetBy: from)
		let endIndex = self.index(self.startIndex, offsetBy: to)
		return String(self[startIndex ..< endIndex])
	}

	func subString(from: Int) -> String {
		let fromIndex = self.index(self.startIndex, offsetBy: from)
		return String(self[fromIndex..<self.endIndex])
	}

	func subString(to: Int) -> String {
		let toIndex = self.index(self.startIndex, offsetBy: to)
		return String(self[self.startIndex..<toIndex])
	}

	// 字符串截取，传入需要截取的字符串开始位置(不按索引算)、结束位置(包含)
	func sub(from: Int = 0, to: Int? = nil) -> String {
		let end = to ?? count
		if count < end { return self } // 避免下标越界

		let start = self.startIndex
		let startIndex = self.index(start, offsetBy: from)
		let endIndex = self.index(start, offsetBy: end)
		return String(self[startIndex ..< endIndex])
	}

	func pregReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
		guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
			return self
		}
		return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.count), withTemplate: with)
	}

	func matches(pattern: String, options: NSRegularExpression.Options = []) -> [NSTextCheckingResult] {
		guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
			return []
		}
		return regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
	}

	func parseURLtoDictionary() -> [String: Any] {
		var res: [String: Any] = [:]
		if let url = URL(string: self) {
			let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
			if let queryItems = components.queryItems {
				for item in queryItems {
					res[item.name] = item.value
				}
			}
		}
		return res
	}

	var asJSON: AnyObject? {
		if let data = self.data(using: .utf8, allowLossyConversion: false) {
			let message = try? JSONSerialization.jsonObject(with: data)
			return message as AnyObject?
		} else {
			return nil
		}
	}
}

public extension String {
    var notiName: NSNotification.Name {
        return NSNotification.Name(rawValue: self)
    }
}
