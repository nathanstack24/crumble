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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crumble"
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 254/255, green: 164/255, blue: 49/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let recipeOfTheDay = Recipe(rating: .good, recipeName: "Shrimp and Gnocci", cookTime: "1 hour 30 min", imageName: "shrimpandgnocci", ingredients: ["shrimp", "gnocci", "cream", "spinach"], displayed: true)
        
        backgroundPic = UIImageView(frame: .zero)
        backgroundPic.translatesAutoresizingMaskIntoConstraints = false
        backgroundPic.contentMode = .scaleAspectFill
        backgroundPic.clipsToBounds = true
        backgroundPic.image = UIImage(named: recipeOfTheDay.imageName)
        view.addSubview(backgroundPic)
        
        recipeOfTheDayLabel = UILabel()
        recipeOfTheDayLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeOfTheDayLabel.text = "Recipe of the Day"
        recipeOfTheDayLabel.textColor = .black
        recipeOfTheDayLabel.font = UIFont(name: "PlayfairDisplay-Bold", size: 18)
        recipeOfTheDayLabel.textAlignment = .center
        recipeOfTheDayLabel.backgroundColor = UIColor(red: 251/255, green: 234/255, blue: 3/255, alpha: 1)
        recipeOfTheDayLabel.layer.shadowColor = UIColor.lightGray.cgColor
        recipeOfTheDayLabel.layer.shadowOffset = CGSize(width: 15, height: 15)
        recipeOfTheDayLabel.layer.shadowRadius = 5.0
        recipeOfTheDayLabel.clipsToBounds = true
        view.addSubview(recipeOfTheDayLabel)
        
        searchButton = UIButton()
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setTitle("Search Recipes", for: .normal)
        searchButton.titleLabel!.font = UIFont(name: "SFProText-Bold", size: 20)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = UIColor(red: 254/255, green: 164/255, blue: 49/255, alpha: 1)
        searchButton.layer.cornerRadius = 25
        searchButton.clipsToBounds = true
        searchButton.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
        view.addSubview(searchButton)
        
        addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("+ Add", for: .normal)
        addButton.titleLabel!.font = UIFont(name: "SFProText-Bold", size: 18)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .white
        addButton.layer.borderWidth = 3
        addButton.layer.borderColor = UIColor(red:49/255, green:142/255, blue:254/255, alpha: 1).cgColor
        addButton.layer.cornerRadius = 20
        addButton.clipsToBounds = true
        addButton.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
        view.addSubview(addButton)
        
        filterButton = UIButton()
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.setTitle("- Filter", for: .normal)
        filterButton.titleLabel!.font = UIFont(name: "SFProText-Bold", size: 18)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.backgroundColor = .white
        filterButton.layer.borderWidth = 3
        filterButton.layer.borderColor = UIColor(red:49/255, green:142/255, blue:254/255, alpha: 1).cgColor
        filterButton.layer.cornerRadius = 20
        filterButton.clipsToBounds = true
        filterButton.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
        view.addSubview(filterButton)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundPic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundPic.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundPic.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //backgroundPic.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
            backgroundPic.heightAnchor.constraint(equalToConstant: 200)
            ])
        NSLayoutConstraint.activate([
            recipeOfTheDayLabel.leadingAnchor.constraint(equalTo: backgroundPic.leadingAnchor),
            recipeOfTheDayLabel.bottomAnchor.constraint(equalTo: backgroundPic.bottomAnchor, constant: -50),
            recipeOfTheDayLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
            recipeOfTheDayLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
        NSLayoutConstraint.activate([
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 30),
            searchButton.heightAnchor.constraint(equalToConstant: 60),
            searchButton.widthAnchor.constraint(equalToConstant: 280)
            ])
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 110)
            ])
        NSLayoutConstraint.activate([
            filterButton.trailingAnchor.constraint(equalTo: searchButton.trailingAnchor),
            filterButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 110)
            ])
    }
    
    @objc func pushViewController() {
        let searchViewController = ViewController()
        //searchViewController.delegate = self
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    
}
