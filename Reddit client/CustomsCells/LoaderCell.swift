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
    
    var loader: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.style = .large
        activity.startAnimating()
        activity.hidesWhenStopped = true
        activity.color = AppConfigurator.mainColor
        return activity
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(loader)
        
        configLoader()
    }
    
    private func configLoader(){
        loader.center =  contentView.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
