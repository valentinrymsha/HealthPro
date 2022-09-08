//
//  AdviceManager.swift
//  HealthPro
//
//  Created by User on 9/8/22.
//

import Foundation

final class AdviceManager {
    
    static func checkUserOnServer(complition: @escaping (RootAdvice?) -> Void) {
        
        let session = URLSession.shared
        
        let api = "https://api.adviceslip.com/advice"
        guard let apiURL = URL(string: api) else { return }
        
        session.dataTask(with: apiURL) { (data, _, error) in
            // Processing of data
            guard error == nil else { return }
            if let data = data {
                let advice = try? JSONDecoder().decode(RootAdvice.self, from: data)
                if let advice = advice {
                    complition(.init(advice))
                    print("success")
                    print(advice)
                    print(advice.slip?.advice)
                } else {
                    complition(nil)
                    print("error")
                }
            }
        }
        .resume()
    }
}


struct RootAdvice: Codable {
    var slip: Slip?
}


struct Slip: Codable {
    var advice: String?
}
