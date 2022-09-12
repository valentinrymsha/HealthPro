//
//  Manager.swift
//  HealthPro
//
//  Created by User on 8/18/22.
//
//  Special thanks are expressed to my neighbor aka <<Nikita>> aka <<Nik>> aka <<Nikolai>>
//    for the time-consuming process of solving the problem with parsing data for recipes


import Foundation

final class RecipeManager {
    
    static func checkUserOnServer(complition: @escaping (Root?) -> Void) {
        
        let session = URLSession.shared
       
        // Keys if >150 requests
        
//        let key1 = "9f40dbb7b8a54e3b9d76a431a5c55615"
//        let key2 = "64e3c271154342c2b257b67ffa540bbc"
        
        let api = "https://api.spoonacular.com/recipes/random?apiKey=c086eddbb7774da5822b81a9f6f45a22&number=50"
        guard let apiURL = URL(string: api) else { return }
      
        session.dataTask(with: apiURL) { (data, _, error) in
            // Processing of data
            guard error == nil else { return }
            if let data = data {
                let recipe = try? JSONDecoder().decode(Root.self, from: data)
                if let recipe = recipe {
                    complition(.init(recipe))
                    print("success")
                    print(recipe)
                    print(recipe.recipes[0].extendedIngredients)
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
    var extendedIngredients: [ExtendedIngredient]
}

struct ExtendedIngredient: Codable {
    var name: String
}
