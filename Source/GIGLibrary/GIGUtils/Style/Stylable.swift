import Foundation

public protocol Stylable {
	associatedtype Style
    func withStyle(_ style: Style)
}

public protocol ViewStylable {
    associatedtype VStyle
    func withViewStyle(_ style: VStyle)
}
