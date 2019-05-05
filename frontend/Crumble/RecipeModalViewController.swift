//
//  RecipeModalViewController.swift
//  eam356_p4
//
//  Created by Beth Mieczkowski on 5/1/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import UIKit

class RecipeModalViewController: UIViewController {
    
    var backgroundPic: UIImageView!
    var pictureHeight: CGFloat!
    var recipeLabel: UILabel!
    var recipeByLabel: UILabel!
    var recipeDescription: UILabel!
    var recipeInstructions: UILabel!
    var recipeInstructionsHeader: UILabel!
    var prepTime: UILabel!
    var cookTime: UILabel!
    var perServing: UILabel!
    var ingredientsHeader: UILabel!
    var ingredientsList: UILabel!
    var refreshControl: UIRefreshControl!
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = recipe.title
        view.backgroundColor = .white
        pictureHeight = 200
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        
        backgroundPic = UIImageView(frame: .zero)
        backgroundPic.translatesAutoresizingMaskIntoConstraints = false
        backgroundPic.contentMode = .scaleAspectFill
        backgroundPic.clipsToBounds = true
        backgroundPic.image = UIImage(data: try! Data(contentsOf: URL(string: recipe.image_url)!))
        view.addSubview(backgroundPic)
        
        recipeLabel = UILabel()
        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeLabel.text = recipe.title
        recipeLabel.textColor = .black
        recipeLabel.font = UIFont(name: "PlayfairDisplay-Bold", size: 25)
        recipeLabel.textAlignment = .center
        view.addSubview(recipeLabel)
        
        recipeByLabel = UILabel()
        recipeByLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeByLabel.text = "Recipe By: " + recipe.author
        recipeByLabel.textColor = .black
        recipeByLabel.font = UIFont(name: "SFProText-Bold", size: 18)
        recipeByLabel.textAlignment = .left
        view.addSubview(recipeByLabel)
        
        prepTime = UILabel()
        prepTime.translatesAutoresizingMaskIntoConstraints = false
        prepTime.text = "Prep Time: " + String(recipe.prep_time)
        prepTime.textColor = .black
        prepTime.font = UIFont(name: "SFProText-Bold", size: 18)
        prepTime.textAlignment = .left
        view.addSubview(prepTime)
        
        cookTime = UILabel()
        cookTime.translatesAutoresizingMaskIntoConstraints = false
        cookTime.text = "Cook Time: " + String(recipe.cook_time)
        cookTime.textColor = .black
        cookTime.font = UIFont(name: "SFProText-Bold", size: 18)
        cookTime.textAlignment = .left
        view.addSubview(cookTime)
        
        perServing = UILabel()
        perServing.translatesAutoresizingMaskIntoConstraints = false
        perServing.text = "Per Serving: " + String(recipe.calories)
        perServing.textColor = .black
        perServing.font = UIFont(name: "SFProText-Bold", size: 18)
        perServing.textAlignment = .left
        view.addSubview(perServing)
        
        recipeDescription = UILabel()
        recipeDescription.translatesAutoresizingMaskIntoConstraints = false
        recipeDescription.text = recipe.description
        recipeDescription.textColor = .black
        recipeDescription.numberOfLines = 0
        recipeDescription.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        recipeDescription.textAlignment = .center
        view.addSubview(recipeDescription)
        
        ingredientsHeader = UILabel()
        ingredientsHeader.translatesAutoresizingMaskIntoConstraints = false
        ingredientsHeader.text = "Ingredients: "
        ingredientsHeader.textColor = .black
        ingredientsHeader.numberOfLines = 0
        ingredientsHeader.font = UIFont(name: "PlayfairDisplay-Bold", size: 24)
        ingredientsHeader.textAlignment = .left
        view.addSubview(ingredientsHeader)
        
        ingredientsList = UILabel()
        ingredientsList.translatesAutoresizingMaskIntoConstraints = false
        var ingredients = ""
        for ingredient in recipe.ingredients {
            ingredients = ingredients + "\n" + " - " + ingredient
        }
        ingredientsList.text = ingredients
        ingredientsList.textColor = .black
        ingredientsList.numberOfLines = 0
        ingredientsList.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        ingredientsList.textAlignment = .left
        view.addSubview(ingredientsList)
        
        recipeInstructionsHeader = UILabel()
        recipeInstructionsHeader.translatesAutoresizingMaskIntoConstraints = false
        recipeInstructionsHeader.text = "Instructions: "
        recipeInstructionsHeader.textColor = .black
        recipeInstructionsHeader.numberOfLines = 0
        recipeInstructionsHeader.font = UIFont(name: "PlayfairDisplay-Bold", size: 24)
        recipeInstructionsHeader.textAlignment = .left
        view.addSubview(recipeInstructionsHeader)
        
        recipeInstructions = UILabel()
        recipeInstructions.translatesAutoresizingMaskIntoConstraints = false
        recipeInstructions.text = recipe.instructions
        recipeInstructions.textColor = .black
        recipeInstructions.numberOfLines = 0
        recipeInstructions.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        recipeInstructions.textAlignment = .left
        view.addSubview(recipeInstructions)
        
         setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundPic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundPic.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundPic.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundPic.heightAnchor.constraint(equalToConstant: pictureHeight)
            ])
        NSLayoutConstraint.activate([
            recipeLabel.topAnchor.constraint(equalTo: backgroundPic.bottomAnchor, constant: 20),
            recipeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipeLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        NSLayoutConstraint.activate([
            recipeByLabel.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 20),
            recipeByLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipeByLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            recipeByLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            prepTime.topAnchor.constraint(equalTo: recipeByLabel.bottomAnchor, constant: 20),
            prepTime.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            prepTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            prepTime.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            cookTime.topAnchor.constraint(equalTo: prepTime.bottomAnchor, constant: 20),
            cookTime.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cookTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            cookTime.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            perServing.topAnchor.constraint(equalTo: cookTime.bottomAnchor, constant: 20),
            perServing.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            perServing.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            perServing.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            recipeDescription.topAnchor.constraint(equalTo: perServing.bottomAnchor, constant: 20),
            recipeDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            recipeDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            recipeDescription.heightAnchor.constraint(equalToConstant: 100)
            ])
        NSLayoutConstraint.activate([
            ingredientsHeader.topAnchor.constraint(equalTo: recipeDescription.bottomAnchor, constant: 20),
            ingredientsHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            ingredientsHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            ingredientsHeader.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            ingredientsList.topAnchor.constraint(equalTo: ingredientsHeader.bottomAnchor, constant: 20),
            ingredientsList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            ingredientsList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            ingredientsList.heightAnchor.constraint(equalToConstant: 200)
            ])
        NSLayoutConstraint.activate([
            recipeInstructionsHeader.topAnchor.constraint(equalTo: ingredientsList.bottomAnchor, constant: 20),
            recipeInstructionsHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            recipeInstructionsHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            recipeInstructionsHeader.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            recipeInstructions.topAnchor.constraint(equalTo: recipeInstructionsHeader.bottomAnchor, constant: 20),
            recipeInstructions.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            recipeInstructions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            recipeInstructions.heightAnchor.constraint(equalToConstant: 300)
            ])
    }
    
    @objc func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pulledToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.refreshControl.endRefreshing()
        }
}

}
