//
//  LikeHeart.swift
//  contraints
//
//  Created by Дмитрий on 29/09/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit

class Like_Heart: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons() {
        
        // Create the button
        let button = UIButton()
        button.backgroundColor = UIColor.red
        
        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        // Setup the button action
        button.addTarget(self, action: #selector(Like_Heart.ratingButtonTapped(button:)), for: .touchUpInside)
        
        // Add the button to the stack
        addArrangedSubview(button)
    }
    @objc func ratingButtonTapped(button: UIButton) {
        print("Button pressed 👍")
    }
}
