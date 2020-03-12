import UIKit

public struct LabelStyle {
    let textStyle: TextStyle
    let viewStyle: ViewStyle?
    
    /// Its possible to set attributted text and ViewStyle to Label individually,
    /// or use this init.
    public init(textStyle: TextStyle,
                viewStyle: ViewStyle? = nil) {
        self.textStyle = textStyle
        self.viewStyle = viewStyle
    }
}
