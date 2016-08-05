
import UIKit

// MARK: PUBLIC 

// MARK: Extensions

public extension String {
    
    /**
     Apply styles to a String
     
     - returns:
     A StyledString
     
     - parameters:
        - styles: List of styles
     
     ````
     "Cool text".style(.Bold,
                       .Underline,
                       .Color(UIColor.redColor()))
     ````
     */
    
    public func style(styles:Style...) -> StyledString {
        
        var styledString = StyledString()
        styledString.styledStringFractions.append(StyledStringFraction(string: self, styles: styles))
        return styledString
    }
}

public extension UILabel {
    
    /**
     Set a StyledString to a Label
     
     ````
     label.styledString = "Cool text".style(.Bold,
                                            .Underline,
                                            .Color(UIColor.redColor()))
     ````
     */
    
    var styledString: StyledString {
        
        get {
            
            return self.styledString
        }
        set(newtStyle) {
            
            self.attributedText = newtStyle.toAttributedString(defaultFont: self.font)
        }
    }
    
    /**
     Set a HTML String to a Label
     
     ````
     label.html = "<b>Important</b> text"
     ````
     */
    
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
    
    public convenience init?(fromHTML html: String) {
        
        try? self.init(data: html.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil)
    }
    
    public convenience init?(fromHTML html: String, font:UIFont, color:UIColor) {
        
        let style = "<style>body{color:\(color.hexString(false)); font-family: '\(font.fontName)'; font-size:" + String(format: "%.0f", font.pointSize) + "px;}</style>"
        let completeHtml = style.stringByAppendingString(html)
        self.init(fromHTML:completeHtml)
    }
}

// MARK: Styled String

public struct StyledString {
    
    var styledStringFractions: [StyledStringFraction] = []
    
    public func toAttributedString(defaultFont font:UIFont) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString()
        let result = styledStringFractions.reduce(attributedString) { (currentAttributedString, singleStyledString) -> NSAttributedString in
            
            let currentString = singleStyledString.string
            let currentStyle = singleStyledString.styles
            
            let tempAttributedString = NSMutableAttributedString(string: currentString)
            
            let attributedString = currentStyle.reduce(tempAttributedString) { (string, style) -> NSMutableAttributedString in
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

// MARK: Overriden operators

/**
 Joins String with a StyledString
 
 - returns:
 A StyledString
 
 
 ````
 "Cool text".style(.Bold, .Underline, .Color(UIColor.redColor())) + " simple text"
 ````
 */
public func +(left: StyledString, right: String) -> StyledString {
    
    var styledText = left
    styledText.styledStringFractions.append(StyledStringFraction(string: right, styles: [Style.None]))
    
    return styledText
}

/**
 Joins String with a StyledString
 
 - returns:
 A StyledString
 
 
 ````
 "This is My " + "Cool text".style(.Bold,
 .Underline,
 .Color(UIColor.redColor()))
 ````
 */
public func +(left: String, right: StyledString) -> StyledString {
    
    var styledText = right
    styledText.styledStringFractions.insert(StyledStringFraction(string:left, styles:[Style.None]), atIndex: 0)
    
    return styledText
}

/**
 Joins String with a StyledString
 
 - returns:
 A StyledString
 
 
 ````
 "This is My ".appleStyles(.Bold) + "Cool text".style(.Bold,
 .Underline,
 .Color(UIColor.redColor()))
 ````
 */
public func +(left: StyledString, right: StyledString) -> StyledString {
    
    var styledText = left
    styledText.styledStringFractions.appendContentsOf(right.styledStringFractions)
    
    return styledText
}


// MARK: PRIVATE

struct StyledStringFraction {
    
    let string: String
    var styles: [Style]
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
