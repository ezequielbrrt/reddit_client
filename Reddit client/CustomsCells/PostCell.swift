//
//  PostCell.swift
//  Reddit client
//
//  Created by beTech CAPITAL on 27/05/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit

class PostCell: UITableViewCell{
    
    var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(postImageView)
        addSubview(titleLabel)
        
        setConstraintsImageView()
        setConstraintsTitleLabel()
    }
    
    func setConstraintsImageView(){
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        postImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setConstraintsTitleLabel(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
