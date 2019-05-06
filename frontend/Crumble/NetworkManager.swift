//
//  NetworkManager.swift
//  Crumble
//
//  Created by Nathan Stack on 5/4/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import Foundation
import Alamofire

let server = "http://34.73.111.81/api/"
let endpoint = server + "recipes/"
let ingredientEndpoint = server + "ingredients/"
let loginEndpoint = server + "user/login/"
let signupEndpoint = server + "user/register/"
let favoriteEndpoint = server + "user/favorite/add/"
let deleteFavoritedEndpoint = server + "user/favorite/remove/"
let getFavoritesEndpoint = server + "user/favorites/"

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
    
    static func postEmailAndPassword(email: String, password: String, completion: @escaping (LoginDetails) -> Void, errorCompletion: @escaping (String) -> Void) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        Alamofire.request(loginEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let loginResponse = try? jsonDecoder.decode(LoginResponseData.self, from: data) {
                    let loginDetails = loginResponse.data
                    completion(loginDetails)
                } else {
                    if let errorResponse = try? jsonDecoder.decode(LoginResponseDataFailure.self, from: data) {
                        let errorMessage = errorResponse.error
                        errorCompletion(errorMessage)
                    } else {
                        print("Error!")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func postNewUser(email: String, name: String, password: String, completion: @escaping (LoginDetails) -> Void, errorCompletion: @escaping (String) -> Void) {
        let parameters: [String: Any] = [
            "name": name,
            "email": email,
            "password": password
        ]
        Alamofire.request(signupEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let signUpResponse = try? jsonDecoder.decode(LoginResponseData.self, from: data) {
                    let signupDetails = signUpResponse.data
                    completion(signupDetails)
                } else {
                    if let errorResponse = try? jsonDecoder.decode(LoginResponseDataFailure.self, from: data) {
                        let errorMessage = errorResponse.error
                        errorCompletion(errorMessage)
                    } else {
                        print("Error!")
                    }
                }
            case .failure(let error):
                print("the post request failed")
                print(error.localizedDescription)
            }
        }
    }
    
    static func postFavoritedRecipe(recipeID: Int, sessionToken: String) {
        let parameters: [String: Any] = [
            "recipe_id": recipeID
        ]
        Alamofire.request(favoriteEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization":sessionToken]).validate().responseData { (response) in
            switch response.result {
            case .success( _):
                print("success (favorited)!")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func deleteFavoritedRecipe(recipeID: Int, sessionToken: String) {
        let parameters: [String: Any] = [
            "recipe_id": recipeID
        ]
        Alamofire.request(deleteFavoritedEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization":sessionToken]).validate().responseData { (response) in
            switch response.result {
            case .success( _):
                print("success (unfavorited)!")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getFavoritedRecipes(sessionToken: String, completion: @escaping ([Recipe]) -> Void) {
        Alamofire.request(getFavoritesEndpoint, method: .get, headers: ["Authorization":sessionToken]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                print("successfully got all favorites")
                let jsonDecoder = JSONDecoder()
                if let favoritesResponse = try? jsonDecoder.decode(FavoritedInfo.self, from: data) {
                    let favorites = favoritesResponse.favorites
                    completion(favorites)
                } else {
                    print("Invalid response data!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
