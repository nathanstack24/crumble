//
//  ProfileViewController.swift
//  Crumble
//
//  Created by Beth Mieczkowski on 4/23/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var nameLabel: UILabel!
    var backgroundPic: UIImageView!
    var recipeLabel: UILabel!
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var favoriteRecipes: [Recipe]!
    let reuseIdentifier = "recipeCellReuse"
    let cellHeight: CGFloat = 250
    let cellSpacingHeight: CGFloat = 20
    let padding: CGFloat = 8
    var user: User!
    
    init(recipes: [Recipe], user: User) {
        self.favoriteRecipes = recipes
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        view.backgroundColor = .white
        

        backgroundPic = UIImageView(frame: .zero)
        backgroundPic.translatesAutoresizingMaskIntoConstraints = false
        backgroundPic.contentMode = .scaleAspectFill
        backgroundPic.clipsToBounds = true
        backgroundPic.image = UIImage(named: "brown")
        view.addSubview(backgroundPic)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "John Food"
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Montserrat-Bold", size: 24)
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)
        
        recipeLabel = UILabel()
        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeLabel.text = "Favorite Recipes"
        recipeLabel.textColor = .black
        recipeLabel.font = UIFont(name: "Montserrat-Bold", size: 24)
        recipeLabel.textAlignment = .center
        view.addSubview(recipeLabel)
        
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecipeCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundPic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundPic.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundPic.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundPic.heightAnchor.constraint(equalToConstant: 200)
            ])
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: backgroundPic.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: backgroundPic.centerYAnchor, constant: 50)
            ])
        NSLayoutConstraint.activate([
            recipeLabel.topAnchor.constraint(equalTo: backgroundPic.bottomAnchor, constant: 15),
            recipeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipeLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
}

extension ProfileViewController: UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return self.favoriteRecipes.count
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
            let recipe = favoriteRecipes[indexPath.section]
            cell.configure(for: recipe)
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
extension ProfileViewController: UITableViewDelegate {
        
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
