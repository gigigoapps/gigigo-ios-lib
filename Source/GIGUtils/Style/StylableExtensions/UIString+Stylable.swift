import UIKit

public extension String {
    func withStyle(_ style: TextStyle) -> NSAttributedString {
        let attributes = [NSAttributedStringKey.font: style.font,
                          NSAttributedStringKey.foregroundColor: style.foregroundColor,
                          NSAttributedStringKey.backgroundColor: style.backgroundColor
        ]
        let attrString = NSMutableAttributedString(string: self, attributes: attributes)
        
        if style.isUnderlined {
            attrString.addAttribute(NSAttributedStringKey.underlineStyle,
                                    value: NSUnderlineStyle.styleSingle.rawValue,
                                    range: NSRange(location: 0, length: attrString.length))
        }
        
        if style.isStrikedThrough {
            attrString.addAttribute(NSAttributedStringKey.strikethroughStyle,
                                    value: 2,
                                    range: NSRange(location: 0, length: attrString.length) )
            attrString.addAttribute(NSAttributedStringKey.strikethroughColor,
                                    value: style.foregroundColor,
                                    range: NSRange(location: 0, length: attrString.length))
        } else if let space = style.letterSpacing {
            attrString.addAttribute(NSAttributedStringKey.kern, value: space, range: NSRange(location: 0, length: attrString.length))
        }
        return attrString
    }
}
