import UIKit

public struct ButtonStyle {
    let textStyle: TextStyle
    let viewStyle: ViewStyle?
    let backgroundImage: UIImage?
    
    // MARK: - Init
    private init(textStyle: TextStyle,
                 viewStyle: ViewStyle? = nil,
                 backgroundImage: UIImage? = nil) {
        self.textStyle = textStyle
        self.viewStyle = viewStyle
        self.backgroundImage = backgroundImage
    }
    
    // MARK: - Styles
    public static var example: ButtonStyle {
        return ButtonStyle(textStyle: TextStyle(font: UIFont.systemFont(ofSize: 10)),
                           viewStyle: ViewStyle())
    }
}
