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
        recipeLabel.font = UIFont(name: "PlayfairDisplay-Bold", size: 24)
        recipeLabel.textAlignment = .center
        view.addSubview(recipeLabel)
        
        recipeByLabel = UILabel()
        recipeByLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeByLabel.text = "Recipe By: " + recipe.author
        recipeByLabel.textColor = .black
        recipeByLabel.font = UIFont(name: "PlayfairDisplay-Bold", size: 18)
        recipeByLabel.textAlignment = .left
        view.addSubview(recipeByLabel)
        
        recipeDescription = UILabel()
        recipeDescription.translatesAutoresizingMaskIntoConstraints = false
        recipeDescription.text = recipe.description
        recipeDescription.textColor = .black
        recipeDescription.numberOfLines = 0
        recipeDescription.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        recipeDescription.textAlignment = .center
        view.addSubview(recipeDescription)
        
        recipeInstructionsHeader = UILabel()
        recipeInstructionsHeader.translatesAutoresizingMaskIntoConstraints = false
        recipeInstructionsHeader.text = "Instructions: "
        recipeInstructionsHeader.textColor = .black
        recipeInstructionsHeader.numberOfLines = 0
        recipeInstructionsHeader.font = UIFont(name: "PlayfairDisplay-Bold", size: 18)
        recipeInstructionsHeader.textAlignment = .center
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
            recipeByLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipeByLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            recipeDescription.topAnchor.constraint(equalTo: recipeByLabel.bottomAnchor, constant: 20),
            recipeDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            recipeDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            recipeDescription.heightAnchor.constraint(equalToConstant: 100)
            ])
        NSLayoutConstraint.activate([
            recipeInstructionsHeader.topAnchor.constraint(equalTo: recipeDescription.bottomAnchor, constant: 20),
            recipeInstructionsHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            recipeInstructionsHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            recipeInstructionsHeader.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            recipeInstructions.topAnchor.constraint(equalTo: recipeDescription.bottomAnchor, constant: 20),
            recipeInstructions.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            recipeInstructions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            recipeInstructions.heightAnchor.constraint(equalToConstant: 300)
            ])
    }
    
    @objc func backAction(){
        dismiss(animated: true, completion: nil)
    }
}
