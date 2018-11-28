import UIKit

extension UILabel: Stylable {
    public func withStyle(_ style: LabelStyle) {
        self.attributedText = self.text?.withStyle(style.textStyle)
        
        if let viewStyle = style.viewStyle {
            self.withViewStyle(viewStyle)
        }
    }
}
