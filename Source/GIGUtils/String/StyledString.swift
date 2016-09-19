
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

public extension UITextView {
    
    /**
     Set a StyledString to a UITextView
     
     ````
     textView.styledString = "Cool text".style(.Bold,
                                        .Underline,
                                        .Color(UIColor.redColor()))
     ````
     */
    
    var styledString: StyledString {
        
        get {
            
            return self.styledString
        }
        set(newtStyle) {
            
            if let font = self.font {
                self.attributedText = newtStyle.toAttributedString(defaultFont: font)
            }
            else {
                let defaultFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
                self.attributedText = newtStyle.toAttributedString(defaultFont: defaultFont)
            }
        }
    }
    
    /**
     Set a HTML String to a UITextView
     
     ````
     textView.html = "<b>Important</b> text"
     ````
     */
    
    var html: String {
        
        get {
            
            return self.html
        }
        set(newtHtml) {
            var font = UIFont.systemFontOfSize(UIFont.systemFontSize());
            var textColor = UIColor.blackColor()
            
            if let currentFont = self.font {
                font = currentFont;
            }
                
            if let currentTextColor = self.textColor {
                textColor = currentTextColor;
            }
                
            self.attributedText = NSAttributedString(fromHTML: newtHtml, font: font, color: textColor)
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
    
    // MARK: PUBLIC
    
    public func toAttributedString(defaultFont font:UIFont) -> NSAttributedString {
        
        let result = styledStringFractions.reduce(NSAttributedString()) { (currentAttributedString, singleStyledString) -> NSAttributedString in
            
            let attributedString = self.attributedStringFrom(styledStringFraction:singleStyledString, font: font)
            
            let finalAttributedString = NSMutableAttributedString(attributedString: currentAttributedString)
            finalAttributedString.appendAttributedString(attributedString)
            
            return finalAttributedString
        }
        return result
    }
    
    // MARK: PRIVATE

    func attributedStringFrom(styledStringFraction styledStringFraction: StyledStringFraction, font:UIFont) -> NSAttributedString {
        
        let currentString = styledStringFraction.string
        let currentStyle = styledStringFraction.styles
        
        
        var currentFont = font;
        
        let tempAttributedString = NSMutableAttributedString(string: currentString)
        let attributedString = currentStyle.reduce(tempAttributedString) { (string, style) -> NSMutableAttributedString in
            
            let key = style.key()
            let value = style.value(forFont: currentFont)
            
            string.addAttribute(key, value:value, range: NSMakeRange(0, string.length))
            
            if (key == NSFontAttributeName) {
                currentFont = style.value(forFont: currentFont) as! UIFont
            }
            return string
        }
        return attributedString;
    }
}

// MARK: Styles

public enum Style {
    
    case None
    case Bold
    case Italic
    case Color(UIColor)
    case BackgroundColor(UIColor)
    case Size(CGFloat)
    case FontName(String)
    case Font(UIFont)
    case Underline
    case UnderlineThick
    case UnderlineDouble
    case UnderlineColor(UIColor)
    case Link(NSURL)
    case BaseLineOffset(CGFloat)

    func key() -> String {
        
        switch self {
            
        case None:
            return ""
        case Bold:
            return NSFontAttributeName
        case Italic:
            return NSFontAttributeName
        case Color:
            return NSForegroundColorAttributeName
        case BackgroundColor:
            return NSBackgroundColorAttributeName
        case Size:
            return NSFontAttributeName
        case FontName:
            return NSFontAttributeName
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
        case Link:
            return NSLinkAttributeName
        case BaseLineOffset:
            return NSBaselineOffsetAttributeName
        }
    }
    
    func value(forFont font: UIFont) -> AnyObject {
        
        switch self {
            
        case None:
            return ""
        case Bold:
            return UIFont(descriptor: font.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitBold), size: 0.0)
        case Italic:
            return UIFont(descriptor: font.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitItalic), size: 0.0)
        case Color(let color):
            return color
        case BackgroundColor(let color):
            return color
        case Size(let pointSize):
            return UIFont(name: font.fontName, size: pointSize)!
        case FontName(let fontName):
            return UIFont(name: fontName, size: font.pointSize)!
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
        case Link(let link):
            return link
        case BaseLineOffset(let offset):
            return offset
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
