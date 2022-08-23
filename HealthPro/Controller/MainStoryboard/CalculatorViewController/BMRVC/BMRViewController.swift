//
//  BMRViewController.swift
//  HealthPro
//
//  Created by User on 8/23/22.
//

import UIKit

class BMRViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var BMRLabel: UILabel!
    
    
    // MARK: Properties

    var currentBMR = 0.15
    var currentSex = String()
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BMRLabel.text = String(round(100*currentBMR)/100) + " Calories/Day"
        sexLabel.text = currentSex
    }
}
