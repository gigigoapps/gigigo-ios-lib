
import UIKit

// MARK: Styled String

public struct StyledString {
    
    let string: String
    var styles: [Style]
}

public struct StyledStringCollection {
    
    var styles: [StyledString] = []
    
    func toAttributedString(defaultFont font:UIFont) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString()
        let result = styles.reduce(attributedString) { (currentAttributedString, styledString) -> NSAttributedString in
            
            let currentString = styledString.string
            let currentStyles = styledString.styles
            
            let tempAttributedString = NSMutableAttributedString(string: currentString)
            
            let attributedString = currentStyles.reduce(tempAttributedString) { (string, style) -> NSMutableAttributedString in
                string.addAttribute(style.key(), value:style.value(forFont: font), range: NSMakeRange(0, string.length))
                return string
            }
            
            let finalAttributedString = NSMutableAttributedString(attributedString: currentAttributedString)
            
            finalAttributedString.appendAttributedString(attributedString)
            return finalAttributedString;
        }
        return result
    }
}

// MARK: Styles

public enum Style {
    
    case None
    case Bold
    case Color(UIColor)
    case BackgroundColor(UIColor)
    case Font(UIFont)
    case Underline
    case UnderlineThick
    case UnderlineDouble
    case UnderlineColor(UIColor)
    
    func key() -> String {
        
        switch self {
            
        case None:
            return ""
        case Bold:
            return NSFontAttributeName
        case Color:
            return NSForegroundColorAttributeName
        case BackgroundColor:
            return NSBackgroundColorAttributeName
        case Font:
            return NSFontAttributeName
        case Underline:
            return NSUnderlineStyleAttributeName
        case UnderlineThick:
            return NSUnderlineStyleAttributeName
        case UnderlineDouble:
            return NSUnderlineStyleAttributeName
        case UnderlineColor:
            return NSUnderlineColorAttributeName
        }
    }
    
    func value(forFont font: UIFont) -> AnyObject {
        
        switch self {
            
        case None:
            return ""
        case Bold:
            return UIFont(descriptor: font.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitBold), size: 0.0)
        case Color(let color):
            return color
        case BackgroundColor(let color):
            return color
        case Font(let font):
            return font
        case Underline:
            return NSUnderlineStyle.StyleSingle.rawValue
        case UnderlineThick:
            return NSUnderlineStyle.StyleThick.rawValue
        case UnderlineDouble:
            return NSUnderlineStyle.StyleDouble.rawValue
        case UnderlineColor(let color):
            return color
        }
    }
}

// MARK: Extensions

public extension String {
    
    func applyStyles(styles:Style...) -> StyledStringCollection {
        
        var styledString = StyledStringCollection()
        styledString.styles.append(StyledString(string: self, styles: styles))
        return styledString
    }
}

public extension UILabel {
    
    var styledString: StyledStringCollection {
        
        get {
            
            return self.styledString
        }
        set(newtStyle) {
            
            self.attributedText = newtStyle.toAttributedString(defaultFont: self.font)
        }
    }
    
    var html: String {
        
        get {
            
            return self.html
        }
        set(newtHtml) {
            
            self.attributedText = NSAttributedString(fromHTML: newtHtml, font: self.font, color: self.textColor)
        }
    }
}

public extension NSAttributedString {
    
    convenience init?(fromHTML html: String) {
        
        try? self.init(data: html.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil)
    }
    
    convenience init?(fromHTML html: String, font:UIFont, color:UIColor) {
        
        let style = "<style>body{color:\(color.hexString(false)); font-family: '\(font.fontName)'; font-size:" + String(format: "%.0f", font.pointSize) + "px;}</style>"
        let completeHtml = style.stringByAppendingString(html)
        self.init(fromHTML:completeHtml)
    }
}

extension UIColor {
    
    public func hexString(includeAlpha: Bool) -> String {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (includeAlpha) {
            
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
}

// MARK: Overriden operators

public func +(left: StyledStringCollection, right: String) -> StyledStringCollection {
    
    var styledCollection = left
    styledCollection.styles.append(StyledString(string: right, styles: [Style.None]))
    
    return styledCollection
}

public func +(left: String, right: StyledStringCollection) -> StyledStringCollection {
    
    var styledCollection = right
    styledCollection.styles.insert(StyledString(string:left, styles:[Style.None]), atIndex: 0)
    
    return styledCollection
}

public func +(left: StyledStringCollection, right: StyledStringCollection) -> StyledStringCollection {
    
    var styledCollection = left
    styledCollection.styles.appendContentsOf(right.styles)
    
    return styledCollection
}
