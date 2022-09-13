//
//  BonusViewController.swift
//  HealthPro
//
//  Created by User on 9/8/22.
//

import UIKit

class BonusViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var getAdviceButton: UIButton!
    @IBOutlet weak var adviceLabelBackView: UIView!
    
    // MARK: Properties
    
    private var rootAdvice: RootAdvice?
    private var slip: Slip?
    
    // MARK: Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adviceLabelBackView.layer.cornerRadius = 13
        getAdviceButton.layer.cornerRadius = 13
    }
    
    // MARK: Actions
    
    @IBAction func didTappedGetAdviceButton(_ sender: UIButton) {
        AdviceManager.checkUserOnServer { root in
            self.rootAdvice = root
            DispatchQueue.main.async { [self] in
                self.slip = self.rootAdvice?.slip
               
                self.adviceLabel.text = slip?.advice
            }
        }
    }
    
}
