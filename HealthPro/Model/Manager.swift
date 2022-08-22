//
//  Manager.swift
//  HealthPro
//
//  Created by User on 8/18/22.
//
//  Special thanks are expressed to my neighbor aka <<Nikita>> aka <<Nik>> aka <<Nikolai>>
//    for the time-consuming process of solving the problem with parsing data for recipes


import Foundation

final class Manager {
    
    static func checkUserOnServer(complition: @escaping (Root?) -> Void) {
        let session = URLSession.shared
        // Get API
        let api = "https://api.spoonacular.com/recipes/random?apiKey=9f40dbb7b8a54e3b9d76a431a5c55615&number=10"
        // Create API URL
        guard let apiURL = URL(string: api) else {
            return
        }
        // Initiallized session
        // Sent dataTask
        print("input")
        session.dataTask(with: apiURL) { (data, _, error) in
            // Processing of data
            guard error == nil else {
                return
            }
            if let data = data {
                let recipe = try? JSONDecoder().decode(Root.self, from: data)
                if let recipe = recipe {
                    complition(.init(recipe))
                    print("success")
                    print(recipe)
                } else {
                    complition(nil)
                    print("error")
                }
            }
        }
        .resume()
    }
}

struct Root: Codable {
    var recipes: [Recipe]
}

struct Recipe: Codable {
    var title: String
    var image: String
}
