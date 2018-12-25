import UIKit

@IBDesignable class BorderShadow: UIView {

    @IBInspectable var radius: CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    func shadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 20
        self.layer.shadowOffset = CGSize.zero
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.blue.cgColor
    }
   
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.setFillColor(UIColor.red.cgColor)
            context.fillEllipse(in: CGRect(x: rect.midX - radius,
                                           y: rect.midY - radius,
                                           width: radius * 5,
                                           height: radius * 5))
            shadow()
            
        }
 

}
