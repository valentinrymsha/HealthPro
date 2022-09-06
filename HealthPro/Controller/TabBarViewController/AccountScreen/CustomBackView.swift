//
//  CustomBackView.swift
//  HealthPro
//
//  Created by User on 9/5/22.
//

import UIKit

class CustomBackView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        
    }
    
}
