//
//  MedicalViewController.swift
//  HealthPro
//
//  Created by User on 8/28/22.
//

import UIKit
import CoreMotion

class MedicalViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var stepsCountLabel: UILabel!
    
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var distanceCountLabel: UILabel!
    
    @IBOutlet weak var floorsView: UIView!
    @IBOutlet weak var floorsCountLabel: UILabel!
    
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var speedCountLabel: UILabel!
    
    @IBOutlet weak var footLengthView: UIView!
    @IBOutlet weak var footLengthlabel: UILabel!
    
    @IBOutlet weak var asymmetryView: UIView!
    @IBOutlet weak var asymmetryCountLabel: UILabel!
    
// MARK: Properties
    
    var pedometer = CMPedometer()
    var countSteps = Int32()
    var distance = Int32()
    var floors = Int32()
    var speed = Int32()
    var length = Int32()
    var asymmetry = Int32()
    
    private func getPedometrInfo() {
        if (!CMPedometer.isStepCountingAvailable()) {
            print("cant counting")
        }
        let calendar = Calendar(identifier: .gregorian)
        DispatchQueue.main.async {
            self.pedometer.queryPedometerData(from: calendar.startOfDay(for: Date()), to: Date(), withHandler: {(pedometerData, error) in
                self.countSteps = (pedometerData?.numberOfSteps.int32Value ?? 0)
                self.distance = (pedometerData?.distance?.int32Value ?? 0)
                self.floors = (pedometerData?.floorsAscended?.int32Value ?? 0)
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
