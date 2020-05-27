//
//  WebService.swift
//  Reddit client
//
//  Created by beTech CAPITAL on 27/05/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation

struct ResourceW<T> {
    let url: URL
    let parse: (Data) -> T?
}

final class WebService {
   
    func load<T>(resource: ResourceW<T>, completion: @escaping (T?) -> ()){
        URLSession.shared.dataTask(with: resource.url){ data, response, error in
            if let data = data{
                DispatchQueue.main.async {
                    completion(resource.parse(data))
                }
                
            }else{
                completion(nil)
            }
        }.resume()
    }
}
