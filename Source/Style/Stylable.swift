import Foundation

protocol Stylable {
	associatedtype Style
    func style(_ style: Style)
}

protocol ViewStylable {
    associatedtype VStyle
    func styleView(_ style: VStyle)
}

//String -> atributtedString
//Views (Labels, Textfields
//    Buttons
//    
//    PageControl
//    Bar
//ViewController
