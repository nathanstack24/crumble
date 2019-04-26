//
//  SearchViewController.swift
//  Crumble
//
//  Created by Beth Mieczkowski on 4/23/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchButton: UIButton!
    var addButton: UIButton!
    var filterButton: UIButton!
    var backgroundPic: UIImageView!
    var recipeOfTheDayLabel: UILabel!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crumble"
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "ChalkboardSE-Bold", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        let lightgray = UIColor.gray
        
        let recipeOfTheDay = Recipe(rating: .good, recipeName: "Shrimp and Gnocci", cookTime: "1 hour 30 min", imageName: "shrimpandgnocci", ingredients: ["shrimp", "gnocci", "cream", "spinach"], displayed: true)
        
        backgroundPic = UIImageView(frame: .zero)
        backgroundPic.translatesAutoresizingMaskIntoConstraints = false
        backgroundPic.contentMode = .scaleAspectFill
        backgroundPic.clipsToBounds = true
        backgroundPic.layer.borderWidth = 1
        backgroundPic.layer.borderColor = lightgray.cgColor
        backgroundPic.image = UIImage(named: recipeOfTheDay.imageName)
        view.addSubview(backgroundPic)
        
        recipeOfTheDayLabel = UILabel()
        recipeOfTheDayLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeOfTheDayLabel.text = "Recipe of the Day"
        recipeOfTheDayLabel.textColor = .black
        recipeOfTheDayLabel.font = UIFont(name: "Verdana-Bold", size: 15)
        recipeOfTheDayLabel.textAlignment = .center
        recipeOfTheDayLabel.backgroundColor = .yellow
        recipeOfTheDayLabel.layer.borderWidth = 1
        recipeOfTheDayLabel.layer.borderColor = UIColor.white.cgColor
        recipeOfTheDayLabel.shadowColor = .gray
        recipeOfTheDayLabel.clipsToBounds = true
        view.addSubview(recipeOfTheDayLabel)
        
        searchButton = UIButton()
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setTitle("Search Recipes", for: .normal)
        searchButton.titleLabel!.font = UIFont(name: "Verdana-Bold", size: 20)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = .orange
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.white.cgColor
        searchButton.layer.cornerRadius = 25
        searchButton.clipsToBounds = true
        searchButton.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
        view.addSubview(searchButton)
        
        addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("+ Add", for: .normal)
        addButton.titleLabel!.font = UIFont(name: "Verdana-Bold", size: 20)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .white
        addButton.layer.borderWidth = 3
        addButton.layer.borderColor = UIColor.blue.cgColor
        addButton.layer.cornerRadius = 20
        addButton.clipsToBounds = true
        addButton.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
        view.addSubview(addButton)
        
        filterButton = UIButton()
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.setTitle("- Filter", for: .normal)
        filterButton.titleLabel!.font = UIFont(name: "Verdana-Bold", size: 20)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.backgroundColor = .white
        filterButton.layer.borderWidth = 3
        filterButton.layer.borderColor = UIColor.blue.cgColor
        filterButton.layer.cornerRadius = 20
        filterButton.clipsToBounds = true
        filterButton.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
        view.addSubview(filterButton)
        
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.isTranslucent = true
        searchBar.placeholder = "Ingredient"
        view.addSubview(searchBar)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundPic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundPic.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundPic.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundPic.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
            ])
        NSLayoutConstraint.activate([
            recipeOfTheDayLabel.leadingAnchor.constraint(equalTo: backgroundPic.leadingAnchor),
            recipeOfTheDayLabel.bottomAnchor.constraint(equalTo: backgroundPic.bottomAnchor, constant: -50),
            recipeOfTheDayLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
            recipeOfTheDayLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchBar.centerYAnchor.constraint(equalTo: backgroundPic.bottomAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
            ])
        NSLayoutConstraint.activate([
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 300)
            ])
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            addButton.centerYAnchor.constraint(equalTo: searchButton.topAnchor, constant: -40),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 115)
            ])
        NSLayoutConstraint.activate([
            filterButton.trailingAnchor.constraint(equalTo: searchButton.trailingAnchor),
            filterButton.centerYAnchor.constraint(equalTo: searchButton.topAnchor, constant: -40),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 115)
            ])
    }
    
    @objc func pushViewController() {
        let searchViewController = ViewController()
        //searchViewController.delegate = self
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    
}
