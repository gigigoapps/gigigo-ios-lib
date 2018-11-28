import UIKit

extension UIButton: Stylable {
    public func withStyle(_ style: ButtonStyle) {
        self.setAttributedTitle(self.currentTitle?.withStyle(style.textStyle), for: .normal)
        
        if let tintColor = style.tintColor {
            self.tintColor = tintColor
        }
        
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
