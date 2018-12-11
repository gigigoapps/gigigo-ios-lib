import UIKit

extension ViewStyle {
    static var viewStyleExample: ViewStyle {
        return ViewStyle(borderColor: UIColor.green,
                         borderWidth: 3.0,
                         someBorders: [.top, .bottom],
                         dottedBorders: false,
                         shadowColor: UIColor.red,
                         shadowOffset: CGSize(width: 2, height: 2),
                         shadowOpacity: 0.5,
                         shadowRadius: 2,
                         cornerRadius: 3,
                         backgroundColor: UIColor.yellow)
    }
    
    static var viewStyleExample2: ViewStyle {
        return ViewStyle(borderColor: UIColor.black,
                         borderWidth: 3.0,
                         dottedBorders: false,
                         backgroundColor: UIColor.cyan)
    }
    
    static var viewStyleExample3: ViewStyle {
        return ViewStyle(borderColor: UIColor.red,
                         borderWidth: 1,
                         cornerRadius: 5,
                         backgroundColor: UIColor.darkGray)
    }
}

@available(iOS 9.0, *)
extension TextViewStyle {
    static var textViewStyleExample:TextViewStyle {
        return TextViewStyle(font: UIFont.systemFont(ofSize: 14),
                             tintColor: UIColor.green,
                             textColor: UIColor.brown,
                             borderStyle: .bezel,
                             viewStyle: .viewStyleExample2)
    }
}

@available(iOS 9.0, *)
extension TextStyle {
    static var textStyleExample: TextStyle {
        return TextStyle(font: UIFont.systemFont(ofSize: 30, weight: .bold),
                         foregroundColor: UIColor.orange,
                         isStrikedThrough: true,
                         isUnderlined: true,
                         letterSpacing: 5)
    }
    static var textStyleExample2: TextStyle {
        return TextStyle(font: UIFont.systemFont(ofSize: 25, weight: .bold),
                         foregroundColor: UIColor.white,
                         letterSpacing: 5)
    }
}

@available(iOS 9.0, *)
extension TextFieldStyle {
    static var textFieldStyleExample: TextFieldStyle {
        return TextFieldStyle(font: UIFont.systemFont(ofSize: 20, weight: .heavy),
                              tintColor: UIColor.red,
                              textColor: UIColor.green,
                              borderStyle: .roundedRect,
                              viewStyle: nil)
    }
}

@available(iOS 9.0, *)
extension LabelStyle {
    static var labelStyleExample: LabelStyle {
        return LabelStyle(textStyle: .textStyleExample, viewStyle: .viewStyleExample)
        
    }
}

@available(iOS 9.0, *)
extension ButtonStyle {
    static var buttonStyleExample: ButtonStyle {
        return ButtonStyle(textStyle: .textStyleExample2,
                           tintColor: nil,
                           viewStyle: .viewStyleExample3,
                           backgroundImage: nil)
    }
}
