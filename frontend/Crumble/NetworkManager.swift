//
//  NetworkManager.swift
//  Crumble
//
//  Created by Nathan Stack on 5/4/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import Foundation
import Alamofire

let endpoint = "http://34.73.111.81/api/recipes/"
let ingredientEndpoint = "http://34.73.111.81/api/ingredients/"

class NetworkManager {
    static func getRecipes(completion: @escaping ([Recipe]) -> Void) {
        Alamofire.request(endpoint, method: .get).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let recipeResponse = try? jsonDecoder.decode(RecipeDataResponse.self, from: data) {
                    let recipes = recipeResponse.data
                    completion(recipes)
                } else {
                    print("Invalid response data!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getIngredients(completion: @escaping ([Ingredient]) -> Void) {
        Alamofire.request(ingredientEndpoint, method: .get).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let ingredientResponse = try? jsonDecoder.decode(IngredientDataResponse.self, from: data) {
                    let ingredients = ingredientResponse.data
                    completion(ingredients)
                } else {
                    print("Invalid response data!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
