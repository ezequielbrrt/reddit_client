//
//  Tools.swift
//  Reddit client
//
//  Created by beTech CAPITAL on 27/05/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit

class Tools: NSObject{

    class func RGB(r : Int, g : Int, b : Int) -> UIColor{
        return UIColor.init(red: RGBNumber(number: r),
                            green: RGBNumber(number: g),
                            blue: RGBNumber(number: b),
                            alpha: 1.0)
    }

    class func RGBNumber(number : Int) -> CGFloat{
           return CGFloat.init(Double(number) / 255.0)
    }
}


extension UITableView {

    ///Show an activity indicator view inside table view at center
    func showLoader(){
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.color = AppConfigurator.mainColor
        activityView.startAnimating()
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(activityView)
        
        activityView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        activityView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
        
    }
    
    /// Restore the table view background, with the option to show separator style
    func restore(showSingleLine: Bool = true) {
        self.backgroundView = nil
        if showSingleLine{
            self.separatorStyle = .singleLine
        }
        
    }
}
