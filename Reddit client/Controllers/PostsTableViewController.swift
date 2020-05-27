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
    private var postListViewModel = PostListViewModel()
    private var initialEffect: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PostCell.self, forCellReuseIdentifier: cellId)

        configureNavigationBar()
        configureRefreshControl()
        populateData()
    }
    
    
    private func populateData(){
        self.tableView.showLoader()
        
        DispatchQueue.main.async {
            WebService().load(resource: self.postListViewModel.postsResource){[weak self] result in
                if (self?.refreshControl!.isRefreshing)!{
                    self?.refreshControl?.endRefreshing()
                }
                if let redditData = result{
                    self?.postListViewModel.postViewModels = redditData.data.children.map(PostViewModel.init)
                    self?.tableView.restore(showSingleLine: true)
                    self?.updateData()

                }
            }
        }
        
    }
    
    
    private func updateData(){
       let dispatchTime = DispatchTime.now() + 0.10;
       DispatchQueue.main.asyncAfter(deadline: dispatchTime){
                      
           if self.initialEffect == false
           {
               self.initialEffect = true
               UIView.transition(with: self.tableView, duration: 0.50,
                                 options: UIView.AnimationOptions.transitionCrossDissolve,
                                 animations: {
                                   self.tableView.reloadData()
                                   
               },
                                 completion: nil)
           }
           else
           {
               UIView.transition(with: self.tableView!, duration: 0.30,
                                 options: UIView.AnimationOptions.transitionCrossDissolve,
                                 animations: {
                                   self.tableView.reloadData()
                                   
               },
                                 completion: nil)
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
        populateData()
    }
    
    //MARK: TABLEVIEW METHODS
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postListViewModel.postViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostCell
        
        let vm = self.postListViewModel.postViewModels[indexPath.row]
        
        cell.post = vm.children.post
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
