//
//  Recipe.swift
//  Crumble
//
//  Created by Beth Mieczkowski on 4/21/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import Foundation
import UIKit

enum RecipeRating {
    case terrible
    case bad
    case moderate
    case good
    case great
}

class Recipe {
        
    var rating: RecipeRating
    var recipeName: String
    var cookTime: String
    var imageName: String
    var ingredients: [String]
    var displayed: Bool
        
    init(rating: RecipeRating, recipeName: String, cookTime: String, imageName: String, ingredients: [String], displayed: Bool) {
        self.rating = rating
        self.recipeName = recipeName
        self.cookTime = cookTime
        self.imageName = imageName
        self.ingredients = ingredients
        self.displayed = displayed
        }
        
}

