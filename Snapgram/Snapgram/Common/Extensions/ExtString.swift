import UIKit

extension NSAttributedString {
    func applyingAttributes(_ attributes: [NSAttributedString.Key: Any], toRange range: NSRange) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.addAttributes(attributes, range: range)
        return NSAttributedString(attributedString: mutableAttributedString)
    }
    
    static func attributedTextWithCustomFont(_ text: String, fontSize: CGFloat, fontName: String, fontWeight: UIFont.Weight, attributes: [NSAttributedString.Key: Any], range: NSRange) -> NSAttributedString {
        let customFont = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        var updatedAttributes = attributes
        updatedAttributes[.font] = customFont
        
        let mutableAttributedString = NSMutableAttributedString(string: text)
        mutableAttributedString.addAttributes(updatedAttributes, range: range)
        
        return NSAttributedString(attributedString: mutableAttributedString)
    }
}
