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
    var scrollView: UIScrollView!
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
        pictureHeight = 300
        let style = NSMutableParagraphStyle.init()
        style.lineSpacing = 10
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = false
        scrollView.contentSize = CGSize(width: 0, height: 2000)
        view.addSubview(scrollView)
        
        backgroundPic = UIImageView(frame: .zero)
        backgroundPic.translatesAutoresizingMaskIntoConstraints = false
        backgroundPic.contentMode = .scaleAspectFill
        backgroundPic.clipsToBounds = true
        backgroundPic.image = UIImage(data: try! Data(contentsOf: URL(string: recipe.image_url)!))
        scrollView.addSubview(backgroundPic)
        
        recipeLabel = UILabel()
        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeLabel.text = recipe.title
        recipeLabel.textColor = UIColor(red: 248/255, green: 123/255, blue: 84/255, alpha: 1)
        recipeLabel.font = UIFont(name: "PlayfairDisplay-Bold", size: 24)
        recipeLabel.numberOfLines = 0
        recipeLabel.lineBreakMode = .byWordWrapping
        recipeLabel.textAlignment = .center
        scrollView.addSubview(recipeLabel)
        
        recipeByLabel = UILabel()
        recipeByLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeByLabel.text = "Recipe By: " + recipe.author
        recipeByLabel.textColor = UIColor(red: 40/255, green: 47/255, blue: 73/255, alpha: 1)
        recipeByLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
        recipeByLabel.numberOfLines = 0
        recipeByLabel.textAlignment = .left
        scrollView.addSubview(recipeByLabel)
        
        prepTime = UILabel()
        prepTime.translatesAutoresizingMaskIntoConstraints = false
        prepTime.text = "Prep Time: " + String(recipe.prep_time) + " mins"
        prepTime.textColor = UIColor(red: 40/255, green: 47/255, blue: 73/255, alpha: 1)
        prepTime.font = UIFont(name: "Montserrat-Regular", size: 16)
        prepTime.textAlignment = .left
        scrollView.addSubview(prepTime)
        
        cookTime = UILabel()
        cookTime.translatesAutoresizingMaskIntoConstraints = false
        cookTime.text = "Cook Time: " + String(recipe.cook_time) + " mins"
        cookTime.textColor = UIColor(red: 40/255, green: 47/255, blue: 73/255, alpha: 1)
        cookTime.font = UIFont(name: "Montserrat-Regular", size: 16)
        cookTime.textAlignment = .left
        scrollView.addSubview(cookTime)
        
        perServing = UILabel()
        perServing.translatesAutoresizingMaskIntoConstraints = false
        perServing.text = "Per Serving: " + String(recipe.calories) + " calories"
        perServing.textColor = UIColor(red: 40/255, green: 47/255, blue: 73/255, alpha: 1)
        perServing.font = UIFont(name: "Montserrat-Regular", size: 16)
        perServing.textAlignment = .left
        scrollView.addSubview(perServing)
        
        recipeDescription = UILabel()
        recipeDescription.translatesAutoresizingMaskIntoConstraints = false
        recipeDescription.text = "“" + recipe.description + "”"
        recipeDescription.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1)
        recipeDescription.numberOfLines = 0
        recipeDescription.font = UIFont(name: "PlayfairDisplay-Regular", size: 16)
        recipeDescription.textAlignment = .center
        scrollView.addSubview(recipeDescription)
        
        ingredientsHeader = UILabel()
        ingredientsHeader.translatesAutoresizingMaskIntoConstraints = false
        ingredientsHeader.text = "Ingredients: "
        ingredientsHeader.textColor = UIColor(red: 40/255, green: 47/255, blue: 73/255, alpha: 1)
        ingredientsHeader.numberOfLines = 0
        ingredientsHeader.font = UIFont(name: "PlayfairDisplay-Bold", size: 20)
        ingredientsHeader.textAlignment = .left
        scrollView.addSubview(ingredientsHeader)
        
        ingredientsList = UILabel()
        ingredientsList.translatesAutoresizingMaskIntoConstraints = false
        var ingredients = ""
        for ingredient in recipe.ingredients {
            ingredients = ingredients + "\n" + " - " + ingredient
        }
        ingredientsList.text = ingredients
        ingredientsList.textColor = UIColor(red: 40/255, green: 47/255, blue: 73/255, alpha: 1)
        ingredientsList.numberOfLines = 0
        ingredientsList.lineBreakMode = .byWordWrapping
        ingredientsList.font = UIFont(name: "Montserrat-Regular", size: 16)
        ingredientsList.textAlignment = .left
        let ingredientsListAttributedString = NSMutableAttributedString.init(string: ingredientsList.text!, attributes: [NSAttributedString.Key.paragraphStyle : style])
        ingredientsList.attributedText = ingredientsListAttributedString
        scrollView.addSubview(ingredientsList)
        
        recipeInstructionsHeader = UILabel()
        recipeInstructionsHeader.translatesAutoresizingMaskIntoConstraints = false
        recipeInstructionsHeader.text = "Instructions: "
        recipeInstructionsHeader.textColor = UIColor(red: 40/255, green: 47/255, blue: 73/255, alpha: 1)
        recipeInstructionsHeader.numberOfLines = 0
        recipeInstructionsHeader.font = UIFont(name: "PlayfairDisplay-Bold", size: 20)
        recipeInstructionsHeader.textAlignment = .left
        scrollView.addSubview(recipeInstructionsHeader)
        
        recipeInstructions = UILabel()
        recipeInstructions.translatesAutoresizingMaskIntoConstraints = false
        recipeInstructions.text = recipe.instructions
        recipeInstructions.textColor = UIColor(red: 40/255, green: 47/255, blue: 73/255, alpha: 1)
        recipeInstructions.numberOfLines = 0
        recipeInstructions.font = UIFont(name: "Montserrat-Regular", size: 16)
        let recipeListAttributedString = NSMutableAttributedString.init(string: recipeInstructions.text!, attributes: [NSAttributedString.Key.paragraphStyle : style])
        recipeInstructions.attributedText = recipeListAttributedString
        recipeInstructions.textAlignment = .left
        scrollView.addSubview(recipeInstructions)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo:view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo:view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])

        NSLayoutConstraint.activate([
            backgroundPic.topAnchor.constraint(equalTo: scrollView.topAnchor),
            backgroundPic.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundPic.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundPic.heightAnchor.constraint(equalToConstant: 240)
            ])
        NSLayoutConstraint.activate([
            recipeLabel.topAnchor.constraint(equalTo: backgroundPic.bottomAnchor, constant: 20),
            recipeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recipeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recipeLabel.heightAnchor.constraint(equalToConstant: 30),
            recipeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
            ])
        NSLayoutConstraint.activate([
            recipeByLabel.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 20),
            recipeByLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipeByLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recipeByLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            prepTime.topAnchor.constraint(equalTo: recipeByLabel.bottomAnchor, constant: 30),
            prepTime.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            prepTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            prepTime.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            cookTime.topAnchor.constraint(equalTo: prepTime.bottomAnchor, constant: 20),
            cookTime.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cookTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cookTime.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            perServing.topAnchor.constraint(equalTo: cookTime.bottomAnchor, constant: 20),
            perServing.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            perServing.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            perServing.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            recipeDescription.topAnchor.constraint(equalTo: perServing.bottomAnchor, constant: 10),
            recipeDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            recipeDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            recipeDescription.heightAnchor.constraint(equalToConstant: 140)
            ])
        NSLayoutConstraint.activate([
            ingredientsHeader.topAnchor.constraint(equalTo: recipeDescription.bottomAnchor, constant: 10),
            //ingredientsHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            ingredientsHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ingredientsHeader.heightAnchor.constraint(equalToConstant: 32)
            ])
        NSLayoutConstraint.activate([
            ingredientsList.topAnchor.constraint(equalTo: ingredientsHeader.bottomAnchor),
            ingredientsList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            ingredientsList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ingredientsList.heightAnchor.constraint(equalToConstant: 160)
            ])
        NSLayoutConstraint.activate([
            recipeInstructionsHeader.topAnchor.constraint(equalTo: ingredientsList.bottomAnchor, constant: 20),
            recipeInstructionsHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recipeInstructionsHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recipeInstructionsHeader.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            recipeInstructions.topAnchor.constraint(equalTo: recipeInstructionsHeader.bottomAnchor, constant: 20),
            recipeInstructions.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recipeInstructions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recipeInstructions.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor, constant: -10)
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
