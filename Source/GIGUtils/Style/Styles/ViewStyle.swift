import UIKit

public struct ViewStyle {
    var borderColor: UIColor
    var borderWidth: CGFloat
    var someBorders: [Border]
    var dottedBorders: Bool
    var cornerRadius: CGFloat?
    var shadowColor: UIColor
    var shadowOffset: CGSize
    var shadowOpacity: Float
    var shadowRadius: CGFloat
    var backgroundColor: UIColor
    
    /// If set dottedBorders, someBorders not apply
    /// If set dottedBorders, someBorders not apply
    public init(borderColor: UIColor = .clear,
                borderWidth: CGFloat = 0.0,
                someBorders: [Border] = [],
                dottedBorders: Bool = false,
                shadowColor: UIColor = .clear,
                shadowOffset: CGSize = CGSize.zero,
                shadowOpacity: Float = 0.0,
                shadowRadius: CGFloat = 0.0,
                cornerRadius: CGFloat? = nil,
                backgroundColor: UIColor = .white) {
        
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.someBorders = someBorders
        self.dottedBorders = dottedBorders
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }
}
