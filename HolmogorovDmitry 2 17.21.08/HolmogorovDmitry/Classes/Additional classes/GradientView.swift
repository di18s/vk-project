import UIKit
//не используется
@IBDesignable class GradientView: UIView {
    
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    @IBInspectable var startColor: UIColor = .white {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var endColor: UIColor = .black {
        didSet {
            updateColors()
        }
    }
    
    //    @IBInspectable var startLocation: CGFloat = 0 {
    //        didSet {
    //            self.updateLocations()
    //        }
    //    }
    //
    //    @IBInspectable var endLocation: CGFloat = 1 {
    //        didSet {
    //            self.updateLocations()
    //        }
    //    }
    //
    //    @IBInspectable var startPoint: CGPoint = .zero {
    //        didSet {
    //            self.updateStartPoint()
    //        }
    //    }
    //
    //    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
    //        didSet {
    //            self.updateEndPoint()
    //        }
    //    }
    
    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor,
                                endColor.cgColor]
    }
    
    
    //    func updateLocations() {
    //        gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
    //    }
    //
    //    func updateStartPoint() {
    //        gradientLayer.startPoint = startPoint
    //    }
    //
    //    func updateEndPoint() {
    //        gradientLayer.endPoint = endPoint
    //    }
}
