
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
    
    public func style(_ styles:Style...) -> StyledString {
        
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
                let defaultFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
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
    
    var html: String? {
        
        get {
            
            return self.html
        }
        set(newtHtml) {
            let string = newtHtml ?? ""
            var font = UIFont.systemFont(ofSize: UIFont.systemFontSize);
            var textColor = UIColor.black
            
            if let currentFont = self.font {
                font = currentFont;
            }
            
            if let currentTextColor = self.textColor {
                textColor = currentTextColor;
            }
            
            self.attributedText = NSAttributedString(fromHTML: string, font: font, color: textColor)
        }
    }
}

public extension NSAttributedString {
    
    public convenience init?(fromHTML html: String) {
        
        try? self.init(data: html.data(using: String.Encoding.utf8)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
    
    public convenience init?(fromHTML html: String, font:UIFont, color:UIColor) {
        
        let style = "<style>body{color:\(color.hexString(false)); font-family: '\(font.fontName)'; font-size:" + String(format: "%.0f", font.pointSize) + "px;}</style>"
        let completeHtml = style + html
        self.init(fromHTML:completeHtml)
    }
}

extension Data {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
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
            finalAttributedString.append(attributedString)
            
            return finalAttributedString
        }
        return result
    }
    
    // MARK: PRIVATE
    
    func attributedStringFrom(styledStringFraction: StyledStringFraction, font:UIFont) -> NSAttributedString {
        
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
    
    case none
    case bold
    case italic
    case color(UIColor)
    case backgroundColor(UIColor)
    case size(CGFloat)
    case fontName(String)
    case font(UIFont)
    case underline
    case underlineThick
    case underlineDouble
    case underlineColor(UIColor)
    case link(URL)
    case baseLineOffset(CGFloat)
    case letterSpacing(CGFloat)
    case centerAligment
    case leftAligment
    case rightAligment
    case lineSpacing(CGFloat)
    
    func key() -> String {
        
        switch self {
            
        case .none:
            return ""
        case .bold:
            return NSFontAttributeName
        case .italic:
            return NSFontAttributeName
        case .color:
            return NSForegroundColorAttributeName
        case .backgroundColor:
            return NSBackgroundColorAttributeName
        case .size:
            return NSFontAttributeName
        case .fontName:
            return NSFontAttributeName
        case .font:
            return NSFontAttributeName
        case .underline:
            return NSUnderlineStyleAttributeName
        case .underlineThick:
            return NSUnderlineStyleAttributeName
        case .underlineDouble:
            return NSUnderlineStyleAttributeName
        case .underlineColor:
            return NSUnderlineColorAttributeName
        case .link:
            return NSLinkAttributeName
        case .baseLineOffset:
            return NSBaselineOffsetAttributeName
        case .letterSpacing:
            return NSKernAttributeName
        case .centerAligment:
            return NSParagraphStyleAttributeName
        case .leftAligment:
            return NSParagraphStyleAttributeName
        case .rightAligment:
            return NSParagraphStyleAttributeName
        case .lineSpacing:
            return NSParagraphStyleAttributeName
        }
    }
    
    func value(forFont font: UIFont) -> AnyObject {
        
        switch self {
            
        case .none:
            return "" as AnyObject
        case .bold:
            if let fontDescriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) {
                return UIFont(descriptor: fontDescriptor, size: 0.0)
            }
            else {
                return font
            }
        case .italic:
            if let fontDescriptor = font.fontDescriptor.withSymbolicTraits(.traitItalic) {
                return UIFont(descriptor: fontDescriptor, size: 0.0)
            }
            else {
                return font
            }
        case .color(let color):
            return color
        case .backgroundColor(let color):
            return color
        case .size(let pointSize):
            return UIFont(name: font.fontName, size: pointSize)!
        case .fontName(let fontName):
            return UIFont(name: fontName, size: font.pointSize)!
        case .font(let font):
            return font
        case .underline:
            return NSUnderlineStyle.styleSingle.rawValue as AnyObject
        case .underlineThick:
            return NSUnderlineStyle.styleThick.rawValue as AnyObject
        case .underlineDouble:
            return NSUnderlineStyle.styleDouble.rawValue as AnyObject
        case .underlineColor(let color):
            return color
        case .link(let link):
            return link as AnyObject
        case .baseLineOffset(let offset):
            return offset as AnyObject
        case .letterSpacing(let spacing):
            return spacing as AnyObject
        case .centerAligment:
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            return paragraphStyle
        case .leftAligment:
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            return paragraphStyle
        case .rightAligment:
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .right
            return paragraphStyle
        case .lineSpacing(let space):
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = space
            return paragraphStyle
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
    styledText.styledStringFractions.append(StyledStringFraction(string: right, styles: [Style.none]))
    
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
    styledText.styledStringFractions.insert(StyledStringFraction(string:left, styles:[Style.none]), at: 0)
    
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
    styledText.styledStringFractions.append(contentsOf: right.styledStringFractions)
    
    return styledText
}


// MARK: PRIVATE

struct StyledStringFraction {
    
    let string: String
    var styles: [Style]
}

extension UIColor {
    
    public func hexString(_ includeAlpha: Bool) -> String {
        
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
