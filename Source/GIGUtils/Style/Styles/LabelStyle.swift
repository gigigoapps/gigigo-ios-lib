import UIKit

public struct LabelStyle {
    let textStyle: TextStyle
    let viewStyle: ViewStyle?
    
    public init(textStyle: TextStyle,
                 viewStyle: ViewStyle? = nil) {
        self.textStyle = textStyle
        self.viewStyle = viewStyle
    }
}
