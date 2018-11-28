import UIKit

extension UITextView: Stylable {
	func style(_ style: TextFieldStyle) {
        self.font = style.font
        self.tintColor = style.tintColor
        self.textColor = style.textColor
        
        if let viewStyle = style.viewStyle {
            self.styleView(viewStyle)
        }
	}
}
