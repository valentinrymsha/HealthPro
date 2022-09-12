//
//  CalculatorViewController.swift
//  HealthPro
//
//  Created by User on 8/23/22.
//

import UIKit

final class CalculatorViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var currentAgeLabel: UILabel!
    @IBOutlet private weak var ageStepper: UIStepper!
    
    @IBOutlet private weak var currentWeightLabel: UILabel!
    @IBOutlet private weak var weightStepper: UIStepper!
    
    @IBOutlet private weak var currentHeightLabel: UILabel!
    @IBOutlet private weak var heightSlider: UISlider!
    
    @IBOutlet private weak var calculateButton: UIButton!
    
    @IBOutlet weak var ageStepperBackView: UIView!
    @IBOutlet weak var weightStepperBackView: UIView!
    @IBOutlet weak var heightSliderBackView: UIView!
    @IBOutlet weak var sexSwitchBackView: UIView!
    
    // MARK: Properties
    
    private var sex = String()
    
    private let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    private func setBackViews() {
        ageStepperBackView.layer.cornerRadius = 13
        weightStepperBackView.layer.cornerRadius = 13
        heightSliderBackView.layer.cornerRadius = 13
        sexSwitchBackView.layer.cornerRadius = 13
        
    }
    
    private func calculateBRMMale() -> Double {
        
        var BMR = Double()
        
            BMR = 6.25 * Double(heightSlider.value) * 100 + 10 * Double(weightStepper.value) + 4.92 * Double(ageStepper.value) + 5
  
        return BMR
    }
    
    private func calculateBRMFemale() -> Double {
        
        var BMR = Double()
        
        BMR = 6.25 * Double(heightSlider.value) * 100 + 10 * Double(weightStepper.value) + 4.92 * Double(ageStepper.value) - 161
  
        return BMR
    }
    
    
    
    // MARK: LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ageStepper.value = 25
        weightStepper.value = 60
        heightSlider.value = 1.75
        
        setBackViews()
        
        sex = "Female"
        
        calculateButton.layer.cornerRadius = 13
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard segue.identifier == "showBMR" else { return }
            guard let destination = segue.destination as? BMRViewController else { return }
        if sex == "Female" {
            destination.currentBMR = calculateBRMFemale()
            destination.currentSex = sex
        } else if sex == "Male" {
            destination.currentBMR = calculateBRMMale()
            destination.currentSex = sex
        }
    }
    // MARK: Actions
    
    @IBAction private func didTouchAgeStep(_ sender: UIStepper) {
        currentAgeLabel.text = Int(sender.value).description
    }
    
    @IBAction private func didTouchWeightStep(_ sender: UIStepper) {
        currentWeightLabel.text = Int(sender.value).description
    }
    
    @IBAction private func didTouchHeightSlider(_ sender: UISlider) {
        currentHeightLabel.text = Float(round(100*sender.value)/100).description
    }
    
    @IBAction private func didTouchSwitcher(_ sender: UISwitch) {
        if sender.isOn {
            sex = "Female"
        } else {
            sex = "Male"
        }
    }
    
    @IBAction private func logoutButton(_ sender: Any) {
        guard let startVC = mainStoryBoard.instantiateViewController(identifier: "StartVC") as? StartViewController else { return }
            present(startVC, animated: false, completion: nil)
    }
}
