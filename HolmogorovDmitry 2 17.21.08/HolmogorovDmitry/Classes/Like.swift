//
//  Like.swift
//  contraints
//
//  Created by Дмитрий on 29/09/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit

class Like: UIView {
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap))
        recognizer.numberOfTapsRequired = 1    // Количество нажатий, необходимое для распознавания
        recognizer.numberOfTouchesRequired = 1 // Количество пальцев, которые должны коснуться экрана для распознавания
        self.addGestureRecognizer(recognizer)
        return recognizer
    }()
    
    
    @objc func onTap() {
        print("Произошло нажатие")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    }
    
//    let rec = UITapGestureRecognizer(target: self, action: #selector(tap))
//    @objc func tap(){
//        print("!!!")
//    }

