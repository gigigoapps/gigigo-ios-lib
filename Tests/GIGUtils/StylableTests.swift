import XCTest
import GIGLibrary

class StylableTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func test_applyStyle_to_String() {
        let stringToTest: String = "Test"
        let textStyle = TextStyle(font: UIFont.systemFont(ofSize: 10),
                                  foregroundColor: .blue,
                                  backgroundColor: .green,
                                  isStrikedThrough: true,
                                  isUnderlined: true,
                                  letterSpacing: 3)
        let attrString = stringToTest.withStyle(textStyle)
        XCTAssertEqual(attrString.attribute(named: NSAttributedString.Key.font.rawValue, forText: stringToTest)as! UIFont, UIFont.systemFont(ofSize: 10))
        XCTAssertEqual(attrString.attribute(named: NSAttributedString.Key.foregroundColor.rawValue, forText: stringToTest)as! UIColor, .blue)
        XCTAssertEqual(attrString.attribute(named: NSAttributedString.Key.backgroundColor.rawValue, forText: stringToTest)as! UIColor, .green)
        XCTAssertNotNil(attrString.attribute(named: NSAttributedString.Key.strikethroughStyle.rawValue, forText: stringToTest))
        XCTAssertNotNil(attrString.attribute(named: NSAttributedString.Key.underlineStyle.rawValue, forText: stringToTest))
//        XCTAssert(attrString.attribute(named: NSAttributedStringKey.kern.rawValue, forText: stringToTest) as! CGFloat == 3)
    }
    
    func test_applyStyle_to_View() {
        let viewStyle = ViewStyle(borderColor: .blue,
                                  borderWidth: 2,
                                  someBorders: [],
                                  dottedBorders: false,
                                  shadowColor: .gray,
                                  shadowOffset: CGSize(width: 3, height: 3),
                                  shadowOpacity: 3.3,
                                  shadowRadius: 4.5,
                                  cornerRadius: 3.2,
                                  backgroundColor: .red)
        let sut = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        sut.withViewStyle(viewStyle)
        
        XCTAssertEqual(sut.layer.borderColor, UIColor.blue.cgColor)
        XCTAssertEqual(sut.layer.borderWidth, 2)
        //some borders
        //dotted borders
        XCTAssertEqual(sut.layer.shadowColor, UIColor.gray.cgColor)
        XCTAssertEqual(sut.layer.shadowOffset, CGSize(width: 3, height: 3))
        XCTAssertEqual(sut.layer.shadowOpacity, 3.3)
        XCTAssertEqual(sut.layer.shadowRadius, 4.5)
        XCTAssertEqual(sut.layer.cornerRadius, 3.2)
        XCTAssertEqual(sut.backgroundColor, .red)
    }
    
    func test_applyStyle_to_TextField() {
        let sut = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let viewStyle = ViewStyle(backgroundColor: .red)
        let textFieldStyle = TextFieldStyle(font: UIFont.systemFont(ofSize: 10),
                                            tintColor: .blue,
                                            textColor: .green,
                                            borderStyle: .bezel,
                                            viewStyle: viewStyle)
        sut.withStyle(textFieldStyle)
        XCTAssertEqual(sut.font, UIFont.systemFont(ofSize: 10))
        XCTAssertEqual(sut.tintColor, .blue)
        XCTAssertEqual(sut.textColor, .green)
        XCTAssertEqual(sut.borderStyle, .bezel)
        XCTAssertEqual(sut.backgroundColor, .red)
    }
    
    func test_applyStyle_to_TextView() {
        let sut = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let viewStyle = ViewStyle(backgroundColor: .red)
        let textViewStyle = TextViewStyle(font: UIFont.systemFont(ofSize: 10),
                                          tintColor: .blue,
                                          textColor: .green,
                                          borderStyle: .bezel,
                                          viewStyle: viewStyle)
        sut.withStyle(textViewStyle)
        XCTAssertEqual(sut.font, UIFont.systemFont(ofSize: 10))
        XCTAssertEqual(sut.tintColor, .blue)
        XCTAssertEqual(sut.textColor, .green)
        XCTAssertEqual(sut.backgroundColor, .red)
    }
    
    func test_applyStyle_to_Label_without_Text() {
        let sut = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let textStyle = TextStyle(font: UIFont.boldSystemFont(ofSize: 12))
        let viewStyle = ViewStyle(borderColor: .red)
        let labelStyle = LabelStyle(textStyle: textStyle, viewStyle: viewStyle)
        sut.withStyle(labelStyle)
        
        XCTAssertEqual(sut.font, UIFont.boldSystemFont(ofSize: 12))
        XCTAssertEqual(sut.layer.borderColor, UIColor.red.cgColor)
    }
    
    func test_applyStyle_to_Label_with_Text() {
        let sut = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let textStyle = TextStyle(font: UIFont.boldSystemFont(ofSize: 12))
        let viewStyle = ViewStyle(borderColor: .red)
        let labelStyle = LabelStyle(textStyle: textStyle, viewStyle: viewStyle)
        sut.text = "Test"
        sut.withStyle(labelStyle)
        
        XCTAssertEqual(sut.font, UIFont.boldSystemFont(ofSize: 12))
        XCTAssertEqual(sut.layer.borderColor, UIColor.red.cgColor)
    }
    
    func test_applyStyle_to_Button_with_text() {
        let sut = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let textStyle = TextStyle(font: UIFont.boldSystemFont(ofSize: 12))
        let viewStyle = ViewStyle(borderColor: .red)
        let buttonStyle = ButtonStyle(textStyle: textStyle,
                                      viewStyle: viewStyle,
                                      backgroundImage: nil)
        sut.setTitle("TEST", for: .normal)
        sut.withStyle(buttonStyle)
        
        XCTAssertEqual(sut.titleLabel?.font, UIFont.boldSystemFont(ofSize: 12))
        XCTAssertEqual(sut.layer.borderColor, UIColor.red.cgColor)
    }
}
