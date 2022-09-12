//
//  WeatherManager.swift
//  HealthPro
//
//  Created by User on 9/7/22.
//

import Foundation

final class WeatherManager {
    
    static func checkUserOnServer(complition: @escaping (RootInfo?) -> Void) {
        
        let session = URLSession.shared
        
        let api = "https://api.weatherapi.com/v1/current.json?key=5f3a50a068e14f65939160010220709&q=Minsk&aqi=no"
        guard let apiURL = URL(string: api) else { return }
        
        session.dataTask(with: apiURL) { (data, _, error) in
            // Processing of data
            guard error == nil else { return }
            if let data = data {
                let current = try? JSONDecoder().decode(RootInfo.self, from: data)
                if let current = current {
                    complition(.init(current))
                    print("success")
                    print(current)
                    print(current.current.condition)
                } else {
                    complition(nil)
                    print("error")
                }
            }
        }
        .resume()
    }
}


struct RootInfo: Codable {
    var current: Current
}


struct Current: Codable {
    var temp_c: Decimal
    var condition: Condition
}
struct Condition: Codable {
    var icon: String
}
