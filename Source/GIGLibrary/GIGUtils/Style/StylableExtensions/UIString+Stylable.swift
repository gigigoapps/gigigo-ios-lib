import UIKit

public extension String {
    func withStyle(_ style: TextStyle) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font: style.font,
                          NSAttributedString.Key.foregroundColor: style.foregroundColor,
                          NSAttributedString.Key.backgroundColor: style.backgroundColor
        ]
        let attrString = NSMutableAttributedString(string: self, attributes: attributes)
        
        if style.isUnderlined {
            attrString.addAttribute(NSAttributedString.Key.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: NSRange(location: 0, length: attrString.length))
        }
        
        if style.isStrikedThrough {
            attrString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                    value: 2,
                                    range: NSRange(location: 0, length: attrString.length) )
            attrString.addAttribute(NSAttributedString.Key.strikethroughColor,
                                    value: style.foregroundColor,
                                    range: NSRange(location: 0, length: attrString.length))
        } else if let space = style.letterSpacing {
            attrString.addAttribute(NSAttributedString.Key.kern, value: space, range: NSRange(location: 0, length: attrString.length))
        }
        return attrString
    }
}
