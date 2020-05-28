//
//  Post.swift
//  Reddit client
//
//  Created by beTech CAPITAL on 27/05/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//




import Foundation


struct RedditData: Codable{
    var kind: String
    var data: RedditPost
    
}

struct RedditPost: Codable {
    let modhash: String
    let dist: Int
    let children: [Children]
    let after: String
    let before: String
}

struct Children: Codable {
    var kind: String?
    var post: Post
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        post = try container.decode(Post.self, forKey: .post)
    }
    
    private enum CodingKeys: String, CodingKey{
        case post = "data"
    }
}

/*
 - Title (at its full length, so take this into account when sizing your cells)
 - Author
 - entry date, following a format like “x hours ago”
 - A thumbnail for those who have a picture.
 - Number of comments
 - Unread status
 
 */

struct Post: Codable {
    var url: String?
    var author: String?
    var author_fullname: String?
    var title: String?
    var num_comments: Int?
    var created_utc: Double?
}
