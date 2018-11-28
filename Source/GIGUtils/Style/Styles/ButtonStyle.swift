import UIKit

public struct ButtonStyle {
    let textStyle: TextStyle
    let tintColor: UIColor?
    let viewStyle: ViewStyle?
    let backgroundImage: UIImage?
    
    /// Its possible to set attributted text and ViewStyle to Label individually,
    /// or use this init.
    
    /// If set backgroundImage backgroundColor from viewStyle is not apply.
    public init(textStyle: TextStyle,
                tintColor: UIColor? = nil,
                viewStyle: ViewStyle? = nil,
                backgroundImage: UIImage? = nil) {
        self.textStyle = textStyle
        self.tintColor = tintColor
        self.viewStyle = viewStyle
        self.backgroundImage = backgroundImage
    }
}
