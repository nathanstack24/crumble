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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchButton = UIButton()
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = .blue
        searchButton.addTarget(self, action: #selector(pushViewController), for: .touchUpInside)
        view.addSubview(searchButton)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 30),
            searchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 24)
            ])
    }
    
    @objc func pushViewController() {
        let searchViewController = ViewController()
        //searchViewController.delegate = self
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    

}
