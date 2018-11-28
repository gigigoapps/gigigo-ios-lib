import UIKit

extension UIButton: Stylable {
    public func withStyle(_ style: ButtonStyle) {
        self.titleLabel?.attributedText = self.titleLabel?.text?.withStyle(style.textStyle)
        self.setTitleColor(style.textStyle.foregroundColor, for: .normal)
        
        if let viewStyle = style.viewStyle {
            self.withViewStyle(viewStyle)
        }
        
        if let image = style.backgroundImage {
            setBackgroundImage(image, for: .normal)
        } else {
            self.backgroundColor = style.viewStyle?.backgroundColor
            if !isEnabled {
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.3)
            }
        }
	}
}
