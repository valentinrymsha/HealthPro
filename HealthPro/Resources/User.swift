//
//  User.swift
//  HealthPro
//
//  Created by User on 8/28/22.
//
//

import Foundation
import RealmSwift

final class User: Object {
        
    @objc dynamic var userName: String?
    @objc dynamic var userPassword: String?
    @objc dynamic var userPhoto: Data?

    
}
