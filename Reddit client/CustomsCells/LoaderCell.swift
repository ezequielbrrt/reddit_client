//
//  LoaderCell.swift
//  Reddit client
//
//  Created by beTech CAPITAL on 27/05/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit

class LoaderCell: UITableViewCell{

    var loaderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.text = "Loading data..."
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(loaderLabel)
        
        configLoader()
    }
    
    private func configLoader(){
        loaderLabel.translatesAutoresizingMaskIntoConstraints = false
        loaderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loaderLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
