import UIKit

extension UILabel: Stylable {
    public func withStyle(_ style: LabelStyle) {
        if let text = self.text {
            self.attributedText = text.withStyle(style.textStyle)
        } else {
            self.font = style.textStyle.font
            self.textColor = style.textStyle.foregroundColor
        }
        
        
        if let viewStyle = style.viewStyle {
            self.withViewStyle(viewStyle)
        }
    }
}
