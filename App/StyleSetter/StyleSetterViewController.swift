import UIKit

@available(iOS 9.0, *)
class StyleSetterViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Style Setter"
        addViews()
    }
    
    private func addViews() {
        let componentWidth: CGFloat = self.view.frame.width
        let componentHeight: CGFloat = 30.0
        let frame = CGRect(x: 0, y: 0, width: componentWidth, height: componentHeight)
        
        let view = UIView(frame: frame)
        view.withViewStyle(.viewStyleExample)
        
        let label = UILabel(frame: frame)
        label.text = "Label text"
        label.withStyle(.labelStyleExample)
        
        let button = UIButton(frame: frame)
        button.setTitle("Button title", for: .normal)
        button.withStyle(.buttonStyleExample)
        
        let textField = UITextField(frame: frame)
        textField.text = "Textfield text"
        textField.withStyle(.textFieldStyleExample)
        
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: componentWidth, height: componentHeight))
        textView.text = "TextView text"
        textView.withStyle(.textViewStyleExample)
        
        stackView.addArrangedSubview(view)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(textView)
    }
    
}


