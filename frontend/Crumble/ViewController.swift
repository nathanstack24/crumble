//
//  ViewController.swift
//  Crumble
//
//  Created by Beth Mieczkowski on 4/21/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import UIKit

protocol ChangeViewControllerButtonTextDelegate: class {
    func textFieldTextChanged(to newString1: String, newString2: String, newString3: String, row: Int)
}

class ViewController: UIViewController {
    
    var tableView: UITableView!
    var collectionView: UICollectionView!
    var recipes: [Recipe]!
    var filterArray: [Filter]!
    var refreshControl: UIRefreshControl!
    var filterLabel: UILabel!
    
    let reuseIdentifier = "recipeCellReuse"
    let filterReuseIdentifier = "filterReuseIdentifier"
    let cellHeight: CGFloat = 250
    let cellSpacingHeight: CGFloat = 20
    let filterHeight: CGFloat = 30
    let padding: CGFloat = 8
    let filterSpace: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search Results"
        view.backgroundColor = .black
        let shrimpandgnocci = Recipe(rating: .good, recipeName: "Shrimp and Gnocci", cookTime: "1 hour 30 min", imageName: "shrimpandgnocci", ingredients: ["shrimp", "gnocci", "cream", "spinach"], displayed: true)
        let tacos = Recipe(rating: .moderate, recipeName: "Texas Chile Short Rib Tacos", cookTime: "30 min", imageName: "tacos", ingredients: ["tortillas", "short rib", "lettuce", "red onion", "sour cream"], displayed: true)
        let porkchops = Recipe(rating: .great, recipeName: "Pan Seared Pork Chops", cookTime: "1 hour", imageName: "porkchops", ingredients: ["pork chops", "bread crumbs"], displayed: true)
        let lemonsoup = Recipe(rating: .good, recipeName: "Lemony Chicken Soup", cookTime: "45 min", imageName: "lemonsoup", ingredients: ["chicken", "heavy cream", "lemon", "chicken broth"], displayed: true)
        let medpasta = Recipe(rating: .bad, recipeName: "Mediterranean Pasta", cookTime: "1 hour 15 min", imageName: "medpasta", ingredients: ["penne", "tomatoes", "spinach", "heavy cream"], displayed: true)
        let salmon = Recipe(rating: .good, recipeName: "Dijon Baked Salmon", cookTime: "45 min", imageName: "salmon", ingredients: ["salmon", "Dijon mustard"], displayed: true)
        let pretzels = Recipe(rating: .moderate, recipeName: "Stuffed Pretzels", cookTime: "20 min", imageName: "pretzels", ingredients: ["flour", "yeast", "cheese"], displayed: true)
        let tuscanpasta = Recipe(rating: .great, recipeName: "Creamy Tuscan Pasta", cookTime: "55 min", imageName: "tuscanpasta", ingredients: ["penne", "chicken", "spinach", "tomato sauce"], displayed: true)
        
        let shrimp = Filter(name: "shrimp", color: .white, isSelected: false)
        let spinach = Filter(name: "spinach", color: .white, isSelected: false)
        let penne = Filter(name: "penne", color: .white, isSelected: false)
        let gnocci = Filter(name: "gnocci", color: .white, isSelected: false)
        let shortrib = Filter(name: "short rib", color: .white, isSelected: false)
        let heavycream = Filter(name: "heavy cream", color: .white, isSelected: false)
        let tomatosauce = Filter(name: "tomato sauce", color: .white, isSelected: false)
        
        recipes = [shrimpandgnocci, tacos, porkchops, lemonsoup, medpasta, salmon, pretzels, tuscanpasta]
        filterArray = [shrimp, spinach, penne, gnocci, shortrib, heavycream, tomatosauce]
        
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
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = padding
        layout2.minimumLineSpacing = padding
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout2)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: filterReuseIdentifier)
        view.addSubview(collectionView)
        
        setupConstraints()
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
    
    @objc func openFilter() {
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.recipes.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    /// Tell the table view what cell to display for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.section]
        cell.configure(for: recipe)
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    /// Tell the table view what height to use for each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// Tell the table view what should happen if we select a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    /// Tell the table view what should happen if we deselect a row
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath) as! FilterCollectionViewCell
            let filter = filterArray[indexPath.item]
            cell.configure(for: filter)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let filterView = collectionView.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath)
            return filterView
    }
}


extension ViewController: UICollectionViewDelegate {
    
    func beginFilter(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func endFilter(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let filter = filterArray[indexPath.item]
            if filter.isSelected == false {
                filter.isSelected = true
                beginFilter(collectionView, didSelectItemAt: indexPath)
                collectionView.reloadData()
            }
            else {
                filter.isSelected = false
                endFilter(collectionView, didSelectItemAt: indexPath)
            }
            collectionView.reloadItems(at: [indexPath])
            collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 75.0, height: 50.0)
    }
    
}




