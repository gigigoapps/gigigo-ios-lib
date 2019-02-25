import UIKit

extension UIView: ViewStylable {
    public func withViewStyle(_ style: ViewStyle) {
        self.backgroundColor = style.backgroundColor
        
        // Shadow
        self.layer.shadowColor = style.shadowColor.cgColor
        self.layer.shadowOffset = style.shadowOffset
        self.layer.shadowOpacity = style.shadowOpacity
        self.layer.shadowRadius = style.shadowRadius
        
        //Borders
        resetBorders()
        
        // All borders
        if style.dottedBorders {
            self.addDottedBorder(weight: style.borderWidth, color: style.borderColor)
        } else if style.someBorders.count == 0 {
            self.addBorder(weight: style.borderWidth, color: style.borderColor)
        }
        // Some borders - not dotted border
        else if style.someBorders.count > 0 {
            style.someBorders.forEach {
                if #available(iOS 9.0, *) {
                    self.addSomeBorders($0, weight: style.borderWidth, color: style.borderColor)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        //Rounded rectangle
        if let cornerRadius = style.cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
}
