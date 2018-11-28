import UIKit

public struct TextFieldStyle {
    let font: UIFont
	let tintColor: UIColor
    let textColor: UIColor
    let borderStyle: UITextBorderStyle
    let viewStyle: ViewStyle?
    
    // MARK: - Init
	private init(font: UIFont,
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

    // MARK: - Styles
	
    public static var example: TextFieldStyle {
        return TextFieldStyle(font: UIFont.systemFont(ofSize: 13.0),
                              textColor: .gray)
    }

}
