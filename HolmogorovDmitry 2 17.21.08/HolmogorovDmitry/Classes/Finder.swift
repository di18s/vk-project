//
//  Finder.swift
//  contraints
//
//  Created by Дмитрий on 30/09/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit

class Finder: UIStackView {
    

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
        button.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 15.0).isActive = true
        
        // Add the button to the stack
        addArrangedSubview(button)
    }

}
