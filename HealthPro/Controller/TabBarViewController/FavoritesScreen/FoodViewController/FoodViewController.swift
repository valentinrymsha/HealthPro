//
//  FoodViewController.swift
//  HealthPro
//
//  Created by User on 8/24/22.
//

import Alamofire
import AlamofireImage
import SwiftyJSON
import UIKit

final class FoodViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var foodImage: UIImageView!
    
    // MARK: Properties
    
    var imageURL: String?
    var image: UIImage?
    
    
    
    private func img() -> UIImage {
        if let imageUrl = imageURL {
        Alamofire.request(imageUrl).responseImage { response in
            if let imag = response.result.value {
                DispatchQueue.main.async {
                    self.image = imag
                }
            }
        }
        }
        return image ?? UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        foodImage.image = img()
        foodImage.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.foodImage.layer.cornerRadius = 8
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.foodImage.image = self.img()
           
        }
        
        
    }
}
