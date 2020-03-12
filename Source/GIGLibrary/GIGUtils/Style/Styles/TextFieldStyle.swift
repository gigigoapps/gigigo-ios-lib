import UIKit

public struct TextFieldStyle {
    let font: UIFont
    let tintColor: UIColor
    let textColor: UIColor
    let borderStyle: UITextField.BorderStyle
    let viewStyle: ViewStyle?
    
    public init(font: UIFont,
                tintColor: UIColor = .blue,
                textColor: UIColor = .black,
                borderStyle: UITextField.BorderStyle = .line,
                viewStyle: ViewStyle? = nil) {
        self.font = font
        self.tintColor = tintColor
        self.textColor = textColor
        self.borderStyle = borderStyle
        self.viewStyle = viewStyle
    }
}
