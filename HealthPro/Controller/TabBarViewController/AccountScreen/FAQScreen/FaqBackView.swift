//
//  FaqBackView.swift
//  HealthPro
//
//  Created by User on 9/7/22.
//

import UIKit

class FaqBackView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners([.bottomLeft, .bottomRight], radius: 50)
        self.backgroundColor = #colorLiteral(red: 0.4227279425, green: 0.6874753237, blue: 0.664511025, alpha: 1).withAlphaComponent(0.7)

    }
    
}
