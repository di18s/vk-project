//
//  DrawObject.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 15/10/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

//Не используется в данный момент
import UIKit

class DrawObject: UIView {

    let cloudColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) //основной цвет нашего UI
    override func draw(_ rect: CGRect) {
        drawCloudShape()
    }
    
    func drawCloudShape() {
        
        let shapeLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath()
        bezierPath.addArc( withCenter: CGPoint(x: UIScreen.main.bounds.width / 2,
                                               y: UIScreen.main.bounds.height / 2),
                           radius: 50.0,
                           startAngle: -5.34,
                           endAngle: -1.05,
                           clockwise: true)
        bezierPath.addArc( withCenter: CGPoint(x: UIScreen.main.bounds.width / 2 + 64,
                                               y: UIScreen.main.bounds.height / 2 - 44),
                           radius: 40.0,
                           startAngle: 3.14,
                           endAngle: CGFloat( 0 ),
                           clockwise: true)
        bezierPath.addArc( withCenter: CGPoint(x: UIScreen.main.bounds.width / 2 + 129,
                                               y: UIScreen.main.bounds.height / 2 - 29),
                           radius: 30.0,
                           startAngle: -2.62,
                           endAngle: CGFloat( -5.76 ),
                           clockwise: true)
        bezierPath.addArc( withCenter: CGPoint(x: UIScreen.main.bounds.width / 2 + 159,
                                               y: UIScreen.main.bounds.height / 2 + 15),
                           radius: 30.0,
                           startAngle: -1.69,
                           endAngle: CGFloat( -3.93 ),
                           clockwise: true)
        bezierPath.addArc( withCenter: CGPoint(x: UIScreen.main.bounds.width / 2 + 112,
                                               y: UIScreen.main.bounds.height / 2 + 21),
                           radius: 30.0,
                           startAngle: -5.76,
                           endAngle: CGFloat( -3.93),
                           clockwise: true)
        bezierPath.addArc( withCenter: CGPoint(x: UIScreen.main.bounds.width / 2 + 60,
                                               y: UIScreen.main.bounds.height / 2 + 25.5),
                           radius: 35.0,
                           startAngle: -5.76,
                           endAngle: CGFloat( -3.62),
                           clockwise: true)
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.path = bezierPath.cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.5
        self.layer.addSublayer(shapeLayer)
        shapeLayer.add(animation, forKey: nil)
    }

}

