import UIKit

public struct TextFieldStyle {
    let font: UIFont
	let tintColor: UIColor
    let textColor: UIColor
    let borderStyle: UITextBorderStyle
    let viewStyle: ViewStyle?
    
	public init(font: UIFont,
	             tintColor: UIColor = .blue,
	             textColor: UIColor = .black,
                 borderStyle: UITextBorderStyle = .line,
                 viewStyle: ViewStyle? = nil) {
		self.font = font
		self.tintColor = tintColor
        self.textColor = textColor
        self.borderStyle = borderStyle
        self.viewStyle = viewStyle
    }
}
