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
        
        filterLabel = UILabel()
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.textColor = .black
        filterLabel.backgroundColor = UIColor(red: 251/255, green: 224/255, blue: 170/255, alpha: 1)
        filterLabel.font = UIFont(name: "Montserrat-Regular", size: 8)
        filterLabel.textAlignment = .center
        filterLabel.layer.borderWidth = 1
        filterLabel.layer.borderColor = UIColor(red: 243/255, green: 185/255, blue: 70/255, alpha: 1).cgColor
        filterLabel.layer.cornerRadius = filterHeight / 2
        filterLabel.clipsToBounds = true
        contentView.addSubview(filterLabel)
        
        xOut = UIButton()
        xOut.translatesAutoresizingMaskIntoConstraints = false
        xOut.setTitle("x", for: .normal)
        xOut.setTitleColor(.black, for: .normal)
        xOut.addTarget(self, action: #selector(clearFilter), for: .touchUpInside)
        contentView.addSubview(xOut)
        
        setupConstraints()
    }
    
    @objc func clearFilter() {
        self.removeFromSuperview()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            filterLabel.heightAnchor.constraint(equalToConstant: 36),
            filterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        NSLayoutConstraint.activate([
            xOut.topAnchor.constraint(equalTo: filterLabel.topAnchor),
            xOut.trailingAnchor.constraint(equalTo: filterLabel.trailingAnchor, constant: -5),
            xOut.widthAnchor.constraint(equalToConstant: 8)
            ])
        filterLabel.textRect(forBounds: CGRect(x: filterLabel.frame.minX, y: filterLabel.frame.minY, width: xOut.frame.minX-filterLabel.frame.minY, height: filterLabel.frame.height), limitedToNumberOfLines: 1)
    }
    
    func configure(for filter: Filter) {
        filterLabel.text = filter.name
    }
    

}

