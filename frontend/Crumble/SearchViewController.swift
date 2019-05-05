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
    var filterLayout: UICollectionView!
    var refreshControl: UIRefreshControl!
    var addedFilters: [Filter]!
    var filterArray: [Filter]!
    var allIngredients: [Ingredient]! = []
    var allRecipes: [Recipe]! = []
    
    let filterReuseIdentifier = "filterReuseIdentifier"
    
    weak var delegate: ChangeSearchViewControllerFilterDelegate?
    
    init(addedFilters: [Filter]) {
        self.addedFilters = addedFilters
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crumble"
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 254/255, green: 164/255, blue: 49/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let recipeOfTheDay =  RecipeOld(rating: .good, recipeName: "Shrimp and Gnocci", cookTime: "1 hour 30 min", imageName: "shrimpandgnocci", ingredients: ["shrimp", "gnocci", "cream", "spinach"], displayed: true, favorited: false)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        
        backgroundPic = UIImageView(frame: .zero)
        backgroundPic.translatesAutoresizingMaskIntoConstraints = false
        backgroundPic.contentMode = .scaleAspectFill
        backgroundPic.clipsToBounds = true
        backgroundPic.image = UIImage(named: "shrimpandgnocci")
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
        filterButton.addTarget(self, action: #selector(removeFilter), for: .touchUpInside)
        view.addSubview(filterButton)
        
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.isTranslucent = true
        searchBar.placeholder = "Ingredient"
        searchBar.showsSearchResultsButton = true
//        searchBar.delegate = self
        view.addSubview(searchBar)
        
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
        addButton.addTarget(self, action: #selector(addFilter), for: .touchUpInside)
        view.addSubview(addButton)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        filterLayout = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filterLayout.translatesAutoresizingMaskIntoConstraints = false
        filterLayout.backgroundColor = .white
        filterLayout.layer.cornerRadius = 10
        filterLayout.layer.borderColor = UIColor.gray.cgColor
        filterLayout.dataSource = self
        filterLayout.delegate = self
        filterLayout.refreshControl = refreshControl
        filterLayout.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: filterReuseIdentifier)
        view.addSubview(filterLayout)
        
        getRecipes()
        getIngredients()
        setUpConstraints()
}
    func getIngredients() {
        NetworkManager.getIngredients { (ingredients) in
            self.allIngredients = ingredients
            print(ingredients)
        }
    }
    
    func getRecipes() {
        NetworkManager.getRecipes { (recipes) in
            self.allRecipes = recipes.shuffled()
        }
    }
    
    @objc func removeFilter() {
        if (filterArray.count != 0) {
            filterArray.remove(at: filterArray.count-1)
        }
        filterLayout.reloadData()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundPic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundPic.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundPic.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundPic.heightAnchor.constraint(equalToConstant: 200)
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
            searchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 300)
            ])
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            addButton.centerYAnchor.constraint(equalTo: searchButton.topAnchor, constant: -40),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 110)
            ])
        NSLayoutConstraint.activate([
            filterButton.trailingAnchor.constraint(equalTo: searchButton.trailingAnchor),
            filterButton.centerYAnchor.constraint(equalTo: searchButton.topAnchor, constant: -40),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 110)
            ])
        NSLayoutConstraint.activate([
            filterLayout.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            filterLayout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            filterLayout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            filterLayout.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 50)
            ])
    }
    
    
    @objc func pulledToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func pushViewController() {
        let viewController = SearchResultsViewController(addedFilters: addedFilters, allRecipes: allRecipes)
        delegate?.pushSearchViewController(to: addedFilters)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filterLayout.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath) as! FilterCollectionViewCell
        let filter = addedFilters[indexPath.item]
        cell.configure(for: filter)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addedFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let filterView = filterLayout.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath)
        return filterView
    }
}


extension SearchViewController: UICollectionViewDelegate {
    
    @objc func addFilter(_ collectionView: UICollectionView) {
        if searchBar.text != "" {
            let ingredient = searchBar.text!
            let filter = filterArray.first(where: {$0.name == ingredient})
            if let addFilter = filter {
                if !addedFilters.contains(where: {$0.name == addFilter.name}) {
                    addedFilters.append(addFilter)
                    addFilter.isSelected = true
                }
            }
        }
        self.filterLayout.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filterArray[indexPath.item]
        if filter.isSelected == false {
            filter.isSelected = true
            collectionView.reloadData()
        }
        else {
            filter.isSelected = false
        }
        collectionView.reloadItems(at: [indexPath])
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 150, height: 100)
    }
    
}



