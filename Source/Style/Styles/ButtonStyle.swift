import UIKit

public struct ButtonStyle {
    let textStyle: TextStyle
    let viewStyle: ViewStyle?
    let backgroundImage: UIImage?
    
    public init(textStyle: TextStyle,
                 viewStyle: ViewStyle? = nil,
                 backgroundImage: UIImage? = nil) {
        self.textStyle = textStyle
        self.viewStyle = viewStyle
        self.backgroundImage = backgroundImage
    }
}
