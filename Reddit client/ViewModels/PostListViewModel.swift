//
//  PostListViewModel.swift
//  Reddit client
//
//  Created by beTech CAPITAL on 27/05/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation

struct PostListViewModel{
    
    var postViewModels = [PostViewModel?]()
    
    let postsResource = ResourceW<RedditData>(url: URL(string:AppConfigurator.APIUrl)!){ data in
        let redditData = try? JSONDecoder().decode(RedditData.self, from: data)
        return redditData
    }
    
    func getPosts(key: String) -> ResourceW<RedditData>?{
        if let url = URL(string: AppConfigurator.APIUrl + "&after=" + key){
            return ResourceW<RedditData>(url: url){ data in
                let redditData = try? JSONDecoder().decode(RedditData.self, from: data)
                return redditData
            }
        }
        return nil

    }
    

    mutating func restorePosts(){
        self.postViewModels = [PostViewModel]()
    }
    
    mutating func addloaderObject(){
        self.postViewModels.append(nil)
    }
    
    mutating func removeLastPost(){
        self.postViewModels.removeLast()
    }
}


struct PostViewModel {
    var children: Children
}
