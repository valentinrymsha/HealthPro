//
//  CustomBackView.swift
//  HealthPro
//
//  Created by User on 9/5/22.
//

import UIKit

class CustomHomeBackView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners([.bottomRight, .bottomLeft], radius: 20)
    }
}
