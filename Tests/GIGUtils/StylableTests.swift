import XCTest
import GIGLibrary

class StylableTests: XCTestCase {
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func setUp() {
        super.setUp()
        
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func test_applySyles_preservesText() {
        let sut: String = "Test"
        let textStyle = TextStyle(font: UIFont.systemFont(ofSize: 10),
                                  foregroundColor: .blue,
                                  backgroundColor: .green,
                                  isStrikedThrough: true,
                                  isUnderlined: true,
                                  letterSpacing: 3)
        let attrString = sut.withStyle(textStyle)
        XCTAssert(attrString.attribute(named: NSAttributedStringKey.font.rawValue, forText: sut)as! UIFont == UIFont.systemFont(ofSize: 10))
    }
}
