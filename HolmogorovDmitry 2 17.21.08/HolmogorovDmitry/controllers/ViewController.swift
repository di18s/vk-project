//
//  ViewController.swift
//  contraints
//
//  Created by Дмитрий on 20/09/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var cloudDrow: UIView!
    @IBOutlet weak var loadViewAnim: UIView!
    @IBOutlet weak var loadViewAnim1: UIView!
    @IBOutlet weak var loadViewAnim2: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var parol: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scroll?.addGestureRecognizer(hideKeyboardGesture)
        let clearButton = UITapGestureRecognizer(target: self, action: #selector(clearBtn))
        loginButton.addGestureRecognizer(clearButton)
    }
    //MARK:- key board funcs
    @objc func keyBoardAppeared(_ notification: Notification) {
        if let keyboardInfo = notification.userInfo as NSDictionary? {
            let size = (keyboardInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)
            self.scroll.contentInset = contentInset
            self.scroll.scrollIndicatorInsets = contentInset
        }
    }

    @objc func keyBoardWasHidden() {
        self.scroll.contentInset = UIEdgeInsets.zero
        self.scroll.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    @objc func hideKeyboard() {
        self.scroll?.endEditing(true)
    }
    
    //MARK:- Action and animation for button
    @objc func clearBtn(){
        if login.text == "" && parol.text == ""{
            self.loginButton.isHidden = true
            self.login.isHidden = true
            self.parol.isHidden = true
            self.loadViewAnim.isHidden = true
            self.loadViewAnim1.isHidden = true
            self.loadViewAnim2.isHidden = true
            drawCloudShape()
            loadAmination()
            delay(0.7) {
                self.performSegue(withIdentifier: "openApp", sender: nil)
            }
        } else {
            print("Failed to login")
        }
    }
    private func loadAmination(){
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.loadViewAnim.alpha = 0.2
        })
        UIView.animate(withDuration: 0.5, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            
            self.loadViewAnim1.alpha = 0.2
        })
        UIView.animate(withDuration: 0.5, delay: 0.6, options: [.repeat, .autoreverse], animations: {
            self.loadViewAnim2.alpha = 0.2
        })
    }
    private func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    //MARK:- Notification
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardAppeared(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWasHidden),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidHideNotification,
                                                  object: nil)
    }
    

    @IBAction func unwindFirst(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }

    private func drawCloudShape() {
        let shapeLayer = CAShapeLayer()
        let bezierPath = UIBezierPath()
        bezierPath.addArc( withCenter: CGPoint(x: view.center.x / 10,
                                               y: view.center.y / 10),
                           radius: 50.0,
                           startAngle: -5.34,
                           endAngle: -1.05,
                           clockwise: true)
        bezierPath.addArc( withCenter: CGPoint(x: view.center.x / 10 + 64,
                                               y: view.center.y / 10 - 44),
                           radius: 40.0,
                           startAngle: 3.14,
                           endAngle: CGFloat( 0 ),
                           clockwise: true)
        bezierPath.addArc( withCenter: CGPoint(x: view.center.x / 10 + 129,
                                               y: view.center.y / 10 - 29),
                           radius: 30.0,
                           startAngle: -2.62,
                           endAngle: CGFloat( -5.76 ),
                           clockwise: true)
        bezierPath.addArc( withCenter: CGPoint(x: view.center.x / 10 + 159,
                                               y: view.center.y / 10 + 15),
                           radius: 30.0,
                           startAngle: -1.69,
                           endAngle: CGFloat( -3.93 ),
                           clockwise: true)
        bezierPath.addArc( withCenter: CGPoint(x: view.center.x / 10 + 112,
                                               y: view.center.y / 10 + 21),
                           radius: 30.0,
                           startAngle: -5.76,
                           endAngle: CGFloat( -3.93),
                           clockwise: true)
        bezierPath.addArc( withCenter: CGPoint(x: view.center.x / 10 + 60,
                                               y: view.center.y / 10 + 25.5),
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
        animation.duration = 2.5
        cloudDrow.layer.addSublayer(shapeLayer)
        shapeLayer.add(animation, forKey: nil)
        cloudDrow.layer.shadowColor = UIColor.yellow.cgColor
        cloudDrow.layer.shadowOpacity = 3.8
        cloudDrow.layer.shadowRadius = 50
        cloudDrow.layer.shadowOffset = CGSize.init(width: 7, height: 0)
        
        self.cloudDrow.transform = CGAffineTransform(translationX: view.bounds.width/2, y: -view.bounds.height/4 )
        UIView.animate(withDuration: 4.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseOut,
                       animations: {
                        self.cloudDrow.transform = .identity
        })
    }

    
    
}

