import UIKit

// MARK: PUBLIC

// MARK: Extensions
// swiftlint:disable file_length

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
    
    func style(_ styles: Style...) -> StyledString {
        
        var styledString = StyledString()
        styledString.styledStringFractions.append(StyledStringFraction(string: self, styles: styles))
        return styledString
    }
}

public extension UILabel {
    
    /**
     Set a StyledString to a Label
     
     ````
     label.styledString("Cool text".style(.Bold,
     .Underline,
     .Color(UIColor.redColor())))
     ````
     */
    var styledString: StyledString? {
        
        @available(*, deprecated, renamed: "styledString()")
        get {
            return nil
        }
        
        set(newtStyle) {
            self.attributedText = newtStyle?.toAttributedString(defaultFont: self.font)
        }
    }
    
    func styledString(_ styledString: StyledString) {
        self.attributedText = styledString.toAttributedString(defaultFont: self.font)
    }
    
    /**
     Set a HTML String to a Label
     
     ````
     label.html("<b>Important</b> text")
     ````
     */
    
    var html: String? {
        
        @available(*, deprecated, renamed: "html()")
        get {
            return nil
        }
        
        set(newtHtml) {
            let string = newtHtml ?? ""
            self.attributedText = NSAttributedString(fromHTML: string, font: self.font, color: self.textColor, aligment: self.textAlignment)
        }
    }
    
    func html(_ html: String?) {
        self.attributedText = NSAttributedString(fromHTML: html ?? "", font: self.font, color: self.textColor, aligment: self.textAlignment)
    }
}

public extension UITextView {
    
    /**
     Set a StyledString to a UITextView
     
     ````
     textView.styledString("Cool text".style(.Bold,
     .Underline,
     .Color(UIColor.redColor())))
     ````
     */
    
    var styledString: StyledString? {
        
        @available(*, deprecated, renamed: "styledString()")
        get {
            return nil
        }
        
        set(newtStyle) {
            
            if let font = self.font {
                self.attributedText = newtStyle?.toAttributedString(defaultFont: font)
            } else {
                let defaultFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                self.attributedText = newtStyle?.toAttributedString(defaultFont: defaultFont)
            }
        }
    }
    
    func styledString(_ styledString: StyledString) {
        if let font = self.font {
            self.attributedText = styledString.toAttributedString(defaultFont: font)
        } else {
            let defaultFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            self.attributedText = styledString.toAttributedString(defaultFont: defaultFont)
        }
    }
    /**
     Set a HTML String to a UITextView
     
     ````
     textView.html("<b>Important</b> text")
     ````
     */
    var html: String? {
        
        @available(*, deprecated, renamed: "html()")
        get {
            return nil
        }
        
        set(newtHtml) {
            let string = newtHtml ?? ""
            var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            var textColor = UIColor.black
            
            if let currentFont = self.font {
                font = currentFont
            }
            
            if let currentTextColor = self.textColor {
                textColor = currentTextColor
            }
            
            self.attributedText = NSAttributedString(fromHTML: string, font: font, color: textColor, aligment: self.textAlignment)
        }
    }
    
    func html(_ html: String?) {
        var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        var textColor = UIColor.black
        
        if let currentFont = self.font {
            font = currentFont
        }
        
        if let currentTextColor = self.textColor {
            textColor = currentTextColor
        }
        
        self.attributedText = NSAttributedString(fromHTML: html ?? "", font: font, color: textColor, aligment: self.textAlignment)
    }
}

public extension NSAttributedString {
    
    convenience init?(fromHTML html: String) {
        
        let htmlData: Data
        if let data = html.data(using: String.Encoding.utf8) {
            htmlData = data
        } else {
            htmlData = Data()
            LogWarn("Could not convert to data from: " + html)
        }
        
        do {
            try self.init(
                data: htmlData,
                options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return nil
        }
    }
    
    convenience init?(fromHTML html: String, font: UIFont, color: UIColor, aligment: NSTextAlignment = .left) {
        self.init(fromHTML: NSAttributedString.createHtml(from: html, fontName: font.fontName, pointSize: font.pointSize, color: color, aligment: aligment))
    }
    
    convenience init?(fromHTML html: String, pointSize: CGFloat, color: UIColor, aligment: NSTextAlignment = .left) {
        self.init(fromHTML: NSAttributedString.createHtml(from: html, fontName: "-apple-system", pointSize: pointSize, color: color, aligment: aligment))
    }
    
    private class func createHtml(from string: String, fontName: String, pointSize: CGFloat, color: UIColor, aligment: NSTextAlignment) -> String {
        let textAligment = aligmentString(fromAligment: aligment)
        let style = "<style>body{color:\(color.hexString(false)); font-family: '\(fontName)'; font-size: \(String(format: "%.0f", pointSize))px; text-align: \(textAligment);}</style>"
        return style + string
    }
}

extension Data {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(
                data: self,
                options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil)
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
    
    public func toAttributedString(defaultFont font: UIFont) -> NSAttributedString {
        
        let result = styledStringFractions.reduce(NSAttributedString()) { (currentAttributedString, singleStyledString) -> NSAttributedString in
            
            let attributedString = self.attributedStringFrom(styledStringFraction: singleStyledString, font: font)
            
            let finalAttributedString = NSMutableAttributedString(attributedString: currentAttributedString)
            finalAttributedString.append(attributedString)
            
            return finalAttributedString
        }
        return result
    }
    
    // MARK: PRIVATE
    
    func attributedStringFrom(styledStringFraction: StyledStringFraction, font: UIFont) -> NSAttributedString {
        
        let currentString = styledStringFraction.string
        let currentStyle = styledStringFraction.styles
        
        var currentFont = font
        
        let tempAttributedString = NSMutableAttributedString(string: currentString)
        let attributedString = currentStyle.reduce(tempAttributedString) { (string, style) -> NSMutableAttributedString in
            
            let key = style.key()
            let value = style.value(forFont: currentFont)
            
            string.addAttribute(NSAttributedString.Key(rawValue: key), value: value, range: NSRange(location: 0, length: string.length))
            
            if key == NSAttributedString.Key.font.rawValue {
                currentFont = style.value(forFont: currentFont) as? UIFont ?? UIFont.systemFont(ofSize: 14)
            }
            return string
        }
        return attributedString
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
    
    // swiftlint:disable cyclomatic_complexity
    func key() -> String {
        
        switch self {
            
        case .none:
            return ""
        case .bold:
            return NSAttributedString.Key.font.rawValue
        case .italic:
            return NSAttributedString.Key.font.rawValue
        case .color:
            return NSAttributedString.Key.foregroundColor.rawValue
        case .backgroundColor:
            return NSAttributedString.Key.backgroundColor.rawValue
        case .size:
            return NSAttributedString.Key.font.rawValue
        case .fontName:
            return NSAttributedString.Key.font.rawValue
        case .font:
            return NSAttributedString.Key.font.rawValue
        case .underline:
            return NSAttributedString.Key.underlineStyle.rawValue
        case .underlineThick:
            return NSAttributedString.Key.underlineStyle.rawValue
        case .underlineDouble:
            return NSAttributedString.Key.underlineStyle.rawValue
        case .underlineColor:
            return NSAttributedString.Key.underlineColor.rawValue
        case .link:
            return NSAttributedString.Key.link.rawValue
        case .baseLineOffset:
            return NSAttributedString.Key.baselineOffset.rawValue
        case .letterSpacing:
            return NSAttributedString.Key.kern.rawValue
        case .centerAligment:
            return NSAttributedString.Key.paragraphStyle.rawValue
        case .leftAligment:
            return NSAttributedString.Key.paragraphStyle.rawValue
        case .rightAligment:
            return NSAttributedString.Key.paragraphStyle.rawValue
        case .lineSpacing:
            return NSAttributedString.Key.paragraphStyle.rawValue
        }
    }
    // swiftlint:disable function_body_length
    func value(forFont font: UIFont) -> AnyObject {
        
        switch self {
            
        case .none:
            return "" as AnyObject
        case .bold:
            if let fontDescriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) {
                return UIFont(descriptor: fontDescriptor, size: 0.0)
            } else {
                return font
            }
        case .italic:
            if let fontDescriptor = font.fontDescriptor.withSymbolicTraits(.traitItalic) {
                return UIFont(descriptor: fontDescriptor, size: 0.0)
            } else {
                return font
            }
        case .color(let color):
            return color
        case .backgroundColor(let color):
            return color
        case .size(let pointSize):
            if let font = UIFont(name: font.fontName, size: pointSize) {
                return font
            } else {
                return UIFont.systemFont(ofSize: pointSize)
            }
        case .fontName(let fontName):
            if let font = UIFont(name: fontName, size: font.pointSize) {
                return font
            } else {
                LogWarn("Could not find font with name: " + fontName)
                return UIFont.systemFont(ofSize: font.pointSize)
            }
        case .font(let font):
            return font
        case .underline:
            return NSUnderlineStyle.single.rawValue as AnyObject
        case .underlineThick:
            return NSUnderlineStyle.thick.rawValue as AnyObject
        case .underlineDouble:
            return NSUnderlineStyle.double.rawValue as AnyObject
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
public func + (left: StyledString, right: String) -> StyledString {
    
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
public func + (left: String, right: StyledString) -> StyledString {
    
    var styledText = right
    styledText.styledStringFractions.insert(StyledStringFraction(string: left, styles: [Style.none]), at: 0)
    
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
public func + (left: StyledString, right: StyledString) -> StyledString {
    
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
        
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
}

func aligmentString(fromAligment aligment: NSTextAlignment) -> String {
    
    switch aligment {
    case .left:
        return "left"
    case .right:
        return "right"
    case .center:
        return "center"
    case .justified:
        return "justified"
    default:
        return "left"
    }
}

