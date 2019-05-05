//
//  RecipeOld.swift
//  Crumble
//
//  Created by Nathan Stack on 5/4/19.
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

class RecipeOld {
    
    var rating: RecipeRating
    var recipeName: String
    var cookTime: String
    var imageName: String
    var ingredients: [String]
    var displayed: Bool
    var favorited: Bool
    
    init(rating: RecipeRating, recipeName: String, cookTime: String, imageName: String, ingredients: [String], displayed: Bool, favorited: Bool) {
        self.rating = rating
        self.recipeName = recipeName
        self.cookTime = cookTime
        self.imageName = imageName
        self.ingredients = ingredients
        self.displayed = displayed
        self.favorited = favorited
    }
    
}
