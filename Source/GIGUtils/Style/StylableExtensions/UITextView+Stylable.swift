import UIKit

extension UITextView: Stylable {
	public func withStyle(_ style: TextViewStyle) {
        self.font = style.font
        self.tintColor = style.tintColor
        self.textColor = style.textColor
        
        if let viewStyle = style.viewStyle {
            self.withViewStyle(viewStyle)
        }
	}
}
