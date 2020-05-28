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
    
    class func feedback(){
        let generator = UIImpactFeedbackGenerator(style:.light)
        generator.impactOccurred()
    }
    
    class func RGB(r : Int, g : Int, b : Int) -> UIColor{
        return UIColor.init(red: RGBNumber(number: r),
                            green: RGBNumber(number: g),
                            blue: RGBNumber(number: b),
                            alpha: 1.0)
    }

    class func RGBNumber(number : Int) -> CGFloat{
           return CGFloat.init(Double(number) / 255.0)
    }
    
    class func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        let imageCache = NSCache<NSString, UIImage>()
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                } else {
                    completion(nil, NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "Error getting image"]))
                }
            }.resume()
        }
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


extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current) + " ago"
    }
}

extension UITableViewController {
  func showToast(message: String, seconds: Double) {
    let alert = UIAlertController(title: nil, message: message,
      preferredStyle: .alert)
    alert.view.backgroundColor = UIColor.white
    alert.view.alpha = 0.6
    alert.view.layer.cornerRadius = 15
    present(alert, animated: true)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
        alert.dismiss(animated: true)
    }
  }
}
