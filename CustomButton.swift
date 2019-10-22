//
//  CustomButton.swift
//  ShoeScan
//
//  This class CustomButton has been applied to buttons in this application
//  Applying this class results in the buttons being rounded around their edges
//
//  Created by Rahul D'Costa on 6/11/19.
//  Copyright © 2019 Nihilent Ltd. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        layer.cornerRadius  = frame.size.height/2
    }
}
