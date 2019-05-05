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
    
    let padding: CGFloat = 8
    let labelHeight: CGFloat = 25
    let recipeImageWidth: CGFloat = 175
    let recipeImageHeight: CGFloat = 100
    let recipeLabelHeight: CGFloat = 25
    let heartImageWidth: CGFloat = 25
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        recipeNameLabel = UILabel()
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeNameLabel.font = UIFont(name: "SFProText-Bold", size: 18)
        recipeNameLabel.clipsToBounds = true
        recipeNameLabel.textColor = UIColor(red: 248/255, green: 123/255, blue: 84/255, alpha: 1)
        contentView.addSubview(recipeNameLabel)
        
        cookTimeLabel = UILabel()
        cookTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        cookTimeLabel.font = UIFont(name: "SFProText-Regular", size: 16)
        cookTimeLabel.textColor = .black
        contentView.addSubview(cookTimeLabel)
        
        recipePhoto = UIImageView(frame: .zero)
        recipePhoto.translatesAutoresizingMaskIntoConstraints = false
        recipePhoto.contentMode = .scaleAspectFill
        recipePhoto.clipsToBounds = true
        contentView.addSubview(recipePhoto)
        
        unfavoritedView = UIImageView(image: #imageLiteral(resourceName: "emptyheart"))
        unfavoritedView.translatesAutoresizingMaskIntoConstraints = false
        unfavoritedView.contentMode = .scaleAspectFit
        unfavoritedView.isHidden = false
        let tapGestureRecognizerUnfavorite = UITapGestureRecognizer(target: self, action: #selector(unfavoritedTapped(tapGestureRecognizer:)))
        unfavoritedView.isUserInteractionEnabled = true
        unfavoritedView.addGestureRecognizer(tapGestureRecognizerUnfavorite)
        contentView.addSubview(unfavoritedView)
        
        favoriteView = UIImageView(image: #imageLiteral(resourceName: "filledheart"))
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
    }
    
    @objc func favoriteTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        favoriteView.isHidden = true
        unfavoritedView.isHidden = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            recipePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            recipePhoto.heightAnchor.constraint(equalToConstant: recipeImageHeight),
            recipePhoto.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            recipePhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        
        NSLayoutConstraint.activate([
            recipeNameLabel.leadingAnchor.constraint(equalTo: recipePhoto.leadingAnchor),
            recipeNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            recipeNameLabel.heightAnchor.constraint(equalToConstant: recipeLabelHeight)
            ])
        
        NSLayoutConstraint.activate([
            cookTimeLabel.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: padding),
            cookTimeLabel.leadingAnchor.constraint(equalTo: recipeNameLabel.leadingAnchor),
            cookTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            ])
        
        NSLayoutConstraint.activate([
            unfavoritedView.trailingAnchor.constraint(equalTo: recipePhoto.trailingAnchor),
            unfavoritedView.centerYAnchor.constraint(equalTo: recipeNameLabel.centerYAnchor),
            unfavoritedView.heightAnchor.constraint(equalToConstant: heartImageWidth),
            unfavoritedView.widthAnchor.constraint(equalToConstant: heartImageWidth)
            ])
        
        NSLayoutConstraint.activate([
            favoriteView.trailingAnchor.constraint(equalTo: recipePhoto.trailingAnchor),
            favoriteView.topAnchor.constraint(equalTo: recipeNameLabel.topAnchor),
            favoriteView.heightAnchor.constraint(equalToConstant: heartImageWidth),
            favoriteView.widthAnchor.constraint(equalToConstant: heartImageWidth)
            ])
    }
    
    func configure(for recipe: Recipe) {
        recipeNameLabel.text = recipe.title
        cookTimeLabel.text = (String) (recipe.cook_time)
        recipePhoto.image = UIImage(data: try! Data(contentsOf: URL(string: recipe.image_url)!))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
