import UIKit

extension UILabel: Stylable {
    func style(_ style: LabelStyle) {
        self.attributedText = self.text?.style(style.textStyle)
        
        if let viewStyle = style.viewStyle {
            self.styleView(viewStyle)
        }
    }
}
