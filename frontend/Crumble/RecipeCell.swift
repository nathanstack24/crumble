//
//  RecipeCell.swift
//  Crumble
//
//  Created by Beth Mieczkowski on 4/21/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

//
//  SongTableViewCell.swift
//  eam356_p4
//
//  Created by Beth Mieczkowski on 3/23/19.
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
    let heartImageWidth: CGFloat = 25
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let lightgray = UIColor.gray
        
        recipeNameLabel = UILabel()
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeNameLabel.font = UIFont(name: "Open Sans Semibold", size: 20)
        recipeNameLabel.textColor = .black
        contentView.addSubview(recipeNameLabel)
        
        cookTimeLabel = UILabel()
        cookTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        cookTimeLabel.font = UIFont(name: "Open Sans Regular", size: 18)
        cookTimeLabel.textColor = .purple
        contentView.addSubview(cookTimeLabel)
        
        recipePhoto = UIImageView(frame: .zero)
        recipePhoto.translatesAutoresizingMaskIntoConstraints = false
        recipePhoto.contentMode = .scaleAspectFill
        recipePhoto.clipsToBounds = true
        recipePhoto.layer.borderWidth = 1
        recipePhoto.layer.borderColor = lightgray.cgColor
        contentView.addSubview(recipePhoto)
        
        unfavoritedView = UIImageView(image: #imageLiteral(resourceName: "emptyheart"))
        unfavoritedView.translatesAutoresizingMaskIntoConstraints = false
        unfavoritedView.contentMode = .scaleAspectFit
        unfavoritedView.isHidden = false
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(unfavoritedTapped(tapGestureRecognizer:)))
        unfavoritedView.isUserInteractionEnabled = true
        unfavoritedView.addGestureRecognizer(tapGestureRecognizer1)
        contentView.addSubview(unfavoritedView)
        
        favoriteView = UIImageView(image: #imageLiteral(resourceName: "filledheart"))
        favoriteView.translatesAutoresizingMaskIntoConstraints = false
        favoriteView.contentMode = .scaleAspectFit
        favoriteView.isHidden = true
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped(tapGestureRecognizer:)))
        favoriteView.isUserInteractionEnabled = true
        favoriteView.addGestureRecognizer(tapGestureRecognizer2)
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
            recipePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipePhoto.heightAnchor.constraint(equalToConstant: recipeImageHeight),
            recipePhoto.widthAnchor.constraint(equalToConstant: recipeImageWidth)
            ])
        
        NSLayoutConstraint.activate([
            recipeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            recipeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            recipeNameLabel.heightAnchor.constraint(equalToConstant: labelHeight)
            ])
        
        NSLayoutConstraint.activate([
            cookTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            cookTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            cookTimeLabel.heightAnchor.constraint(equalToConstant: labelHeight)
            ])
        
        NSLayoutConstraint.activate([
            unfavoritedView.leadingAnchor.constraint(equalTo: cookTimeLabel.trailingAnchor, constant: padding),
            unfavoritedView.topAnchor.constraint(equalTo: cookTimeLabel.topAnchor),
            unfavoritedView.heightAnchor.constraint(equalToConstant: heartImageWidth),
            unfavoritedView.widthAnchor.constraint(equalToConstant: heartImageWidth)
            ])
        
        NSLayoutConstraint.activate([
            favoriteView.leadingAnchor.constraint(equalTo: cookTimeLabel.trailingAnchor, constant: padding),
            favoriteView.topAnchor.constraint(equalTo: cookTimeLabel.topAnchor),
            favoriteView.heightAnchor.constraint(equalToConstant: heartImageWidth),
            favoriteView.widthAnchor.constraint(equalToConstant: heartImageWidth)
            ])
    }
    
    func configure(for recipe: Recipe) {
        recipeNameLabel.text = recipe.recipeName
        cookTimeLabel.text = recipe.cookTime
        recipePhoto.image = UIImage(named: recipe.imageName)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
