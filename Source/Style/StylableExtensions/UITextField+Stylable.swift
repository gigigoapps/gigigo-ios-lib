import UIKit

extension UITextField: Stylable {
    func style(_ style: TextFieldStyle) {
        self.font = style.font
        self.tintColor = style.tintColor
        self.textColor = style.textColor
		self.borderStyle = style.borderStyle

        if let viewStyle = style.viewStyle {
            self.styleView(viewStyle)
        }
    }
}
