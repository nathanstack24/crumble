//
//  ViewController.swift
//  Crumble
//
//  Created by Beth Mieczkowski on 4/21/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    var tableView: UITableView!
    var collectionView: UICollectionView!
    var recipes: [Recipe]! = []
    var refreshControl: UIRefreshControl!
    var filterLabel: UILabel!
    var addedFilters: [Filter]! = []
    var selectedRecipes: [Recipe]! = []
    
    let reuseIdentifier = "recipeCellReuse"
    let filterReuseIdentifier = "filterReuseIdentifier"
    let cellHeight: CGFloat = 250
    let cellSpacingHeight: CGFloat = 20
    let filterHeight: CGFloat = 30
    let padding: CGFloat = 8
    let filterSpace: CGFloat = 20
    
    init(addedFilters: [Filter], allRecipes: [Recipe]) {
        self.addedFilters = addedFilters
        recipes = allRecipes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search Results"
        view.backgroundColor = .black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(pushProfileViewController))
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        
        // Initialize tableView
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecipeCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        filterLabel = UILabel()
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.text = "Filter"
        filterLabel.textColor = .white
        filterLabel.font = UIFont(name: "SFProText-Bold", size: 16)
        filterLabel.textAlignment = .center
        filterLabel.backgroundColor = UIColor(red:49/255, green:142/255, blue:254/255, alpha: 1)
        filterLabel.layer.cornerRadius = 20
        filterLabel.clipsToBounds = true
        view.addSubview(filterLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        collectionView.register(AddedFiltersCollectionViewCell.self, forCellWithReuseIdentifier: filterReuseIdentifier)
        view.addSubview(collectionView)
        
        setupConstraints()
        setupSelectedRecipes()
    }
    
    func setupSelectedRecipes() {
        
        for rec in recipes {
            for fil in addedFilters {
                let upperCaseFilter = fil.name.uppercased(with: .current)
                for ingredient in rec.ingredients {
                    let upperCaseIngredient = ingredient.uppercased(with: .current)
                    if upperCaseIngredient.contains(upperCaseFilter) {
                        if !selectedRecipes.contains(where: { (recipe) -> Bool in
                            return recipe.title==rec.title
                        }) {
                            selectedRecipes.append(rec)
                        }
                    }
                }
                
            }
        }
        self.collectionView.reloadData()
    }
    
    func setupConstraints() {
        // Setup the constraints for our views
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        NSLayoutConstraint.activate([
            filterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            filterLabel.heightAnchor.constraint(equalToConstant: 40),
            filterLabel.widthAnchor.constraint(equalToConstant: 110)
            ])
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
    
    @objc func pushProfileViewController() {
        let viewController = ProfileViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushRecipeModalViewController(recipe: Recipe) {
        let viewController = RecipeModalViewController(recipe: recipe)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedRecipes.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedRecipes.count
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    /// Tell the table view what cell to display for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RecipeCell
        let recipe = selectedRecipes[indexPath.row]
        cell.configure(for: recipe)
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension SearchResultsViewController: UITableViewDelegate {
    
    /// Tell the table view what height to use for each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// Tell the table view what should happen if we select a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = selectedRecipes[indexPath.row]
        pushRecipeModalViewController(recipe: recipe)
    }
}

extension SearchResultsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath) as! AddedFiltersCollectionViewCell
        let filter = addedFilters[indexPath.item]
        cell.configure(for: filter)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addedFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let filterView = collectionView.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath)
        return filterView
    }
}


extension SearchResultsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
        }
    }

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("in function")
        return CGSize(width: 100.0, height: 50.0)
    }
    
}
