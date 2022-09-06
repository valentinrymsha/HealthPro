//
//  RealmUserModel.swift
//  HealthPro
//
//  Created by User on 9/3/22.
//
//

import Foundation
import RealmSwift

class UserModel: Object {
    @objc dynamic var userName: String?
    @objc dynamic var userPassword: String?
    @objc dynamic var isLoggined: Bool = false
    @objc dynamic var userImage: Data = Data(UIImage(named: "user-4")!.pngData()!)
    
    override static func primaryKey() -> String? {
          return "userName"
    }
}
