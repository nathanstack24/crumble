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
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = "Recipe"
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
        recipeLabel.text = "Shrimp and Gnocci"
        recipeLabel.textColor = .black
        recipeLabel.font = UIFont(name: "PlayfairDisplay-Bold", size: 24)
        recipeLabel.textAlignment = .center
        view.addSubview(recipeLabel)
        
        recipeByLabel = UILabel()
        recipeByLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeByLabel.text = "Recipe Made By: Beth Mieczkowski"
        recipeByLabel.textColor = .black
        recipeByLabel.font = UIFont(name: "PlayfairDisplay-Bold", size: 14)
        recipeByLabel.textAlignment = .center
        view.addSubview(recipeByLabel)
        
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
    }
    
    @objc func backAction(){
        dismiss(animated: true, completion: nil)
    }
}
