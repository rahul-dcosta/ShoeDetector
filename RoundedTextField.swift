//
//  RoundedTextField.swift
//  ShoeScan
//
//  Created by Rahul D'Costa on 7/8/19.
//  Copyright © 2019 Nihilent Ltd. All rights reserved.
//

import Foundation
import UIKit

class RoundedTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    private func setupTextField() {
        layer.cornerRadius  = frame.size.height/2
    }
}
