//
//  Shop.swift
//  HealthPro
//
//  Created by User on 9/2/22.
//

import Foundation
import MapKit
import UIKit

class Shop: NSObject, MKAnnotation {
    
    var name: String
    
    var coordinate: CLLocationCoordinate2D
    
    init(_ name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        
        self.coordinate = coordinate
    }
}
