//
//  MainViewController.swift
//  Reddit client
//
//  Created by beTech CAPITAL on 27/05/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit

class PostsTableViewController: UITableViewController{
    
    private var cellId = "PostCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PostCell.self, forCellReuseIdentifier: cellId)

        configureNavigationBar()
        configureRefreshControl()
        
        populateData()
    }
    
    
    private func populateData(){
        let postURL = URL(string:AppConfigurator.APIUrl)!
        
        let postsResource = ResourceW<RedditData>(url: postURL){ data in
            let redditData = try? JSONDecoder().decode(RedditData.self, from: data)
            return redditData
            
        }
        
        WebService().load(resource: postsResource){[weak self] result in
            if let redditData = result{
                print(redditData)
            }
        }
    }
    
    
    private func configureNavigationBar(){
        self.view.backgroundColor = .white
        self.navigationItem.title = "Reddit posts"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureRefreshControl(){
        let refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshPostData(_:)), for: .valueChanged)
    }
        
    @objc func refreshPostData(_ sender: UIRefreshControl){
        
    }
    
    //MARK: TABLEVIEW METHODS
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostCell
        
        cell.postImageView.backgroundColor = .black
        cell.titleLabel.text = "Test"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
