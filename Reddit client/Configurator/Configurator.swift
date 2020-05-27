//
//  Configurator.swift
//  Reddit client
//
//  Created by beTech CAPITAL on 27/05/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation

class AppConfigurator: NSObject{
    
    // MARK: API
    static let APIUrl: String = "https://www.reddit.com/r/all/top/.json?t=all&limit=10"
    
    
    // MARK: COLORS
    static let mainColor = Tools.RGB(r: 56, g: 230, b: 207)
    static let secondaryColor = Tools.RGB(r: 70, g: 193, b: 128)
    
    static let mainColorHex = "38e6cf"
    static let secondaryColorHex = ""
    
}
