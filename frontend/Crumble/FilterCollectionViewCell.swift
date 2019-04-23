//
//  FilterCollectionViewCell.swift
//  Crumble
//
//  Created by Beth Mieczkowski on 4/21/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    var filterLabel: UILabel!
    var filterHeight: CGFloat = 20
    var xOut: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let lightgray = UIColor.gray
        filterLabel = UILabel()
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.textColor = .black
        filterLabel.backgroundColor = .white
        filterLabel.font = UIFont(name: "Open Sans Regular", size: 8)
        filterLabel.textAlignment = .center
        filterLabel.layer.borderWidth = 1
        filterLabel.layer.borderColor = lightgray.cgColor
        filterLabel.layer.cornerRadius = filterHeight / 2
        filterLabel.clipsToBounds = true
        contentView.addSubview(filterLabel)
        
        xOut = UIButton()
        xOut.translatesAutoresizingMaskIntoConstraints = false
        xOut.setTitle("x", for: .normal)
        xOut.setTitleColor(.black, for: .normal)
        xOut.addTarget(self, action: #selector(endFilter), for: .touchUpInside)
        contentView.addSubview(xOut)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filterLabel.heightAnchor.constraint(equalToConstant: 50),
            filterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
//        NSLayoutConstraint.activate([
//            xOut.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
//            xOut.leadingAnchor.constraint(equalTo: filterLabel.trailingAnchor, constant: 5)
//            ])
    }
    
    func configure(for filter: Filter) {
//        filterLabel.text = filter.name
//        if filter.isSelected {
//            filter.displayed = false
//            filterLabel.backgroundColor = .white
//        }
//        else {
//            filterLabel.backgroundColor = .white
//        }
    }
    
    @objc func endFilter() {
        
    }
    
}

