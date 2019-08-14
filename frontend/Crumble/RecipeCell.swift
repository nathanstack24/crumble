//
//  RecipeCell.swift
//  Crumble
//
//  Created by Beth Mieczkowski on 4/21/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//


import UIKit

class RecipeCell: UITableViewCell {
    
    var recipeNameLabel: UILabel!
    var cookTimeLabel: UILabel!
    var recipePhoto: UIImageView!
    var favoriteView: UIImageView!
    var unfavoritedView: UIImageView!
    var user: User!
    var recipeID: Int!
    
//    let padding: CGFloat = 20
//    let labelHeight: CGFloat = 20
//    let recipeImageWidth: CGFloat = 175
//    let recipeImageHeight: CGFloat = 240
//    let recipeLabelHeight: CGFloat = 24
//    let heartImageWidth: CGFloat = 24
    
    override func layoutSubviews() {
        // Set the width of the cell
        self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width - 40, height: self.bounds.size.height)
        super.layoutSubviews()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        recipeNameLabel = UILabel()
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeNameLabel.font = getDefaultAppFont(ofSize: 16)
        recipeNameLabel.clipsToBounds = true
        recipeNameLabel.lineBreakMode = .byWordWrapping
        recipeNameLabel.numberOfLines = 0
        recipeNameLabel.textColor = UIColor(red: 248/255, green: 123/255, blue: 84/255, alpha: 1)
        contentView.addSubview(recipeNameLabel)
        
        cookTimeLabel = UILabel()
        cookTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        cookTimeLabel.font = UIFont(name: "Montserrat-Regular", size: 16)
        cookTimeLabel.textColor = .black
        contentView.addSubview(cookTimeLabel)
        
        recipePhoto = UIImageView(frame: .zero)
        recipePhoto.translatesAutoresizingMaskIntoConstraints = false
        recipePhoto.contentMode = .scaleAspectFill
        recipePhoto.clipsToBounds = true
        contentView.addSubview(recipePhoto)
        
        unfavoritedView = UIImageView(image: #imageLiteral(resourceName: "emptystar"))
        unfavoritedView.translatesAutoresizingMaskIntoConstraints = false
        unfavoritedView.contentMode = .scaleAspectFit
        unfavoritedView.isHidden = false
        let tapGestureRecognizerUnfavorite = UITapGestureRecognizer(target: self, action: #selector(unfavoritedTapped(tapGestureRecognizer:)))
        unfavoritedView.isUserInteractionEnabled = true
        unfavoritedView.addGestureRecognizer(tapGestureRecognizerUnfavorite)
        contentView.addSubview(unfavoritedView)
        
        favoriteView = UIImageView(image: #imageLiteral(resourceName: "filledstar"))
        favoriteView.translatesAutoresizingMaskIntoConstraints = false
        favoriteView.contentMode = .scaleAspectFit
        favoriteView.isHidden = true
        let tapGestureRecognizerFavorite = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped(tapGestureRecognizer:)))
        favoriteView.isUserInteractionEnabled = true
        favoriteView.addGestureRecognizer(tapGestureRecognizerFavorite)
        contentView.addSubview(favoriteView)
        
        setupConstraints()
    }
    
    @objc func unfavoritedTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        unfavoritedView.isHidden = true
        favoriteView.isHidden = false
        NetworkManager.postFavoritedRecipe(recipeID: recipeID, sessionToken: user.session_token)
    }
    
    @objc func favoriteTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        favoriteView.isHidden = true
        unfavoritedView.isHidden = false
        NetworkManager.deleteFavoritedRecipe(recipeID: recipeID, sessionToken: user.session_token)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            recipePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipePhoto.heightAnchor.constraint(equalToConstant: 150),
            recipePhoto.topAnchor.constraint(equalTo: self.topAnchor),
            recipePhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            recipeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recipeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 165),
            recipeNameLabel.trailingAnchor.constraint(equalTo: unfavoritedView.leadingAnchor, constant: -10),
            recipeNameLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            cookTimeLabel.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 0),
            cookTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cookTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
        
        NSLayoutConstraint.activate([
            unfavoritedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            unfavoritedView.topAnchor.constraint(equalTo: recipeNameLabel.topAnchor),
            unfavoritedView.heightAnchor.constraint(equalToConstant: 20),
            unfavoritedView.widthAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            favoriteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteView.topAnchor.constraint(equalTo: recipeNameLabel.topAnchor),
            favoriteView.heightAnchor.constraint(equalToConstant: 20),
            favoriteView.widthAnchor.constraint(equalToConstant: 20)
            ])
    }
    
    func configure(for recipe: Recipe) {
        recipeNameLabel.text = recipe.title
        if ((recipe.total_time) == -1) {
            cookTimeLabel.text = "Total Time: " + "Unavailable"
        }
        else if (((recipe.total_time)/60) == 0) {
            cookTimeLabel.text = "Total Time: " + (String) ((recipe.total_time)%60) + " mins"
        }
        else if ((((recipe.total_time)/60)/24) == 0) {
            cookTimeLabel.text = "Total Time: " + (String) ((recipe.total_time)/60) + " hrs " + (String) ((recipe.total_time)%60) + " mins"
        }
        else {
            cookTimeLabel.text = "Total Time: " + (String) (((recipe.total_time)/60)/24) + " days " + (String) (((recipe.total_time)/60)%24) + " hrs " + (String) ((recipe.total_time)%60) + " mins"
        }
        recipePhoto.image = UIImage(data: try! Data(contentsOf: URL(string: recipe.image_url)!))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
