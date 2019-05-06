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
    var profileBtn: UIButton!
    
    let reuseIdentifier = "recipeCellReuse"
    let filterReuseIdentifier = "filterReuseIdentifier"
    let cellHeight: CGFloat = 250
    let cellSpacingHeight: CGFloat = 100
    let filterHeight: CGFloat = 30
    let padding: CGFloat = 8
    let filterSpace: CGFloat = 20
    var currentUser: User!
    var favoritedRecipes: [Recipe]! = []
    
    init(addedFilters: [Filter], allRecipes: [Recipe], currentUser: User) {
        self.addedFilters = addedFilters
        self.currentUser = currentUser
        recipes = allRecipes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search Results"
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        profileBtn = UIButton()
        profileBtn.setImage(UIImage(named: "profile"), for: .normal) //set image for button
        profileBtn.translatesAutoresizingMaskIntoConstraints = false
        profileBtn.addTarget(self, action: #selector(pushProfileViewController), for: .touchUpInside)
        profileBtn.widthAnchor.constraint(equalToConstant: 28).isActive = true
        profileBtn.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        //assign button to navigationbar
        let barButton = UIBarButtonItem(customView: profileBtn)
        self.navigationItem.rightBarButtonItem = barButton
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        
        // Initialize tableView
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none //hide the horizontal lines
        tableView.register(RecipeCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        filterLabel = UILabel()
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.text = "Filter"
        filterLabel.textColor = .white
        filterLabel.font = UIFont(name: "Mentserrat-SemiBold", size: 16)
        filterLabel.textAlignment = .center
        filterLabel.backgroundColor = UIColor(red:49/255, green:142/255, blue:254/255, alpha: 1)
        filterLabel.layer.cornerRadius = 20
        filterLabel.clipsToBounds = true
        filterLabel.isHidden = true
        view.addSubview(filterLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //collectionView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        collectionView.register(AddedFiltersCollectionViewCell.self, forCellWithReuseIdentifier: filterReuseIdentifier)
        view.addSubview(collectionView)
        
        setupConstraints()
        setupSelectedRecipes()
    }
    
    func setupSelectedRecipes() {
        selectedRecipes = []
        for rec in recipes {
            var match = true
            for fil in addedFilters {
                let upperCaseFilter = fil.name.uppercased(with: .current)
                var ingredMatch = false
                for ingredient in rec.ingredients {
                    let upperCaseIngredient = ingredient.uppercased(with: .current)
                    if upperCaseIngredient.contains(upperCaseFilter) {
                        ingredMatch = true
                    }
                }
                if !ingredMatch {
                    match = false
                }
            }
            if !selectedRecipes.contains(where: { (recipe) -> Bool in
                return recipe.id==rec.id
            }) {
                if (match) {
                    selectedRecipes.append(rec)
                }
            }
        }
        
        if (addedFilters.count == 0) {
            selectedRecipes = self.recipes
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
            //collectionView.heightAnchor.constraint(equalToConstant: 50),
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
        collectionView.reloadData()
    }
    
    @objc func pushProfileViewController() {
        NetworkManager.getFavoritedRecipes(sessionToken: currentUser.session_token) { (recipes) in
            self.favoritedRecipes = recipes
            for rec in recipes {
                print(rec.title)
            }
        }
        let viewController = ProfileViewController(recipes: self.favoritedRecipes, user: self.currentUser)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushRecipeModalViewController(recipe: Recipe) {
        let viewController = RecipeModalViewController(recipe: recipe)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        
        cell.layer.cornerRadius = 8
        //cell.layer.masksToBounds = true
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowRadius = 5
        cell.user = currentUser
        cell.recipeID = recipe.id
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
        return CGSize(width: 100.0, height: 50.0)
    }
    
}
