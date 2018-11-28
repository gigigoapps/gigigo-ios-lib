import UIKit

public struct LabelStyle {
    let textStyle: TextStyle
    let viewStyle: ViewStyle?
    
    // MARK: - Init
    private init(textStyle: TextStyle,
                 viewStyle: ViewStyle? = nil) {
        self.textStyle = textStyle
        self.viewStyle = viewStyle
    }
    
    // MARK: - Styles
    public static var example: LabelStyle {
        return LabelStyle(textStyle: TextStyle(font: UIFont.systemFont(ofSize: 10)),
                          viewStyle: ViewStyle())
    }
}
