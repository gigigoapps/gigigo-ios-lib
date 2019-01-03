import UIKit

public enum Border: Int {
    case left
    case right
    case top
    case bottom
}

private final class BorderView: UIView { }

public extension UIView {
    
    @available(iOS 9.0, *)
    func addSomeBorders(_ border: Border, weight: CGFloat, color: UIColor) {
		
		resetBorder(border)
        
        let lineView = BorderView()
		lineView.tag = border.rawValue
        addSubview(lineView)
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        switch border {
            
        case .left:
            lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            lineView.widthAnchor.constraint(equalToConstant: weight).isActive = true
            
        case .right:
            lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            lineView.widthAnchor.constraint(equalToConstant: weight).isActive = true
            
        case .top:
            lineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            lineView.heightAnchor.constraint(equalToConstant: weight).isActive = true
            
        case .bottom:
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            lineView.heightAnchor.constraint(equalToConstant: weight).isActive = true
        }
    }
    
    func addBorder(weight: CGFloat, color: UIColor) {
        self.layer.borderWidth = weight
        self.layer.borderColor = color.cgColor
    }
	
    func addDottedBorder(weight: CGFloat, color: UIColor) {
        let border = CAShapeLayer()
        border.cornerRadius = self.layer.cornerRadius
        border.strokeColor = color.cgColor
        border.fillColor = UIColor.clear.cgColor
        border.lineDashPattern = [4, 2]
		border.lineWidth = weight
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.addSublayer(border)
    }
	
	func resetBorder(_ border: Border) {
		self.subviews.filter { $0 is BorderView && $0.tag == border.rawValue }.forEach { $0.removeFromSuperview() }
	}
	
	func resetBorders() {
		// Remove all previous BorderView subviews (solid borders)
		self.subviews.filter { $0 is BorderView }.forEach { $0.removeFromSuperview() }
		// Remove all CAShapeLayer sublayers from layer (dotted borders)
		self.layer.sublayers?.filter({ $0 is CAShapeLayer }).forEach({ $0.removeFromSuperlayer() })
    }

	func roundCorners(corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		let rect = self.bounds
		mask.frame = rect
		mask.path = path.cgPath
		self.layer.mask = mask
	}
}
