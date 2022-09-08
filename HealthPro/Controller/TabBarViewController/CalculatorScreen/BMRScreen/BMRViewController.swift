//
//  BMRViewController.swift
//  HealthPro
//
//  Created by User on 8/23/22.
//

import UIKit

final class BMRViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var sexLabel: UILabel!
    @IBOutlet private weak var BMRLabel: UILabel!
    @IBOutlet private weak var slimBMRLabel: UILabel!
    @IBOutlet private weak var gainBMRLabel: UILabel!
    
    
    // MARK: Properties

    var currentBMR = Double()
    var currentSex = String()
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BMRLabel.text = String(round(100*currentBMR)/100) + " Calories/Day"
        slimBMRLabel.text = String(round(100*(currentBMR - 253.06))/100) + " Calories/Day"
        gainBMRLabel.text = String(round(100*(currentBMR + 253.27))/100) + " Calories/Day"
        
        sexLabel.text = currentSex
    }
}
