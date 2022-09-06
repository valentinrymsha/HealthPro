//
//  Shop.swift
//  HealthPro
//
//  Created by User on 9/2/22.
//

import Foundation
import MapKit
import UIKit

final class Shop: NSObject, MKAnnotation {
    
    var title: String?
    
    var coordinate: CLLocationCoordinate2D
    
    init(_ title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        
        self.coordinate = coordinate
    }
}
