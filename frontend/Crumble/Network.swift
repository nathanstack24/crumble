//
//  RecipeNetwork.swift
//  Crumble
//
//  Created by Nathan Stack on 5/4/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import Foundation

struct Recipe : Codable {
    var id: Int
    var title: String
    var author: String
    var source: String
    var description: String
    var rating: Float
    var num_reviews: String
    var prep_time: Int
    var cook_time: Int
    var total_time: Int
    var servings: Int
    var calories: Int
    var fat: Float
    var carbs: Float
    var protein: Float
    var cholesterol: Int
    var sodium: Int
    var instructions: String
    var image_url: String
    var ingredients: [String]
    var tags: [String]
}

struct RecipeDataResponse: Codable {
    var success: Bool
    var num_results: Int
    var data: [Recipe]
}

struct LoginDetails: Codable {
    var session_token: String
    var session_expiration: String
    var update_token: String
}

struct LoginResponseData: Codable {
    var success: Bool
    var data: LoginDetails
}

struct LoginResponseDataFailure: Codable {
    var success: Bool
    var error: String
}

struct FavoritedInfo: Codable {
    var success: Bool
    var favorites: [Recipe]
}


