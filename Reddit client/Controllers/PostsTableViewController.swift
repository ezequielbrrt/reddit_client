//
//  MainViewController.swift
//  Reddit client
//
//  Created by beTech CAPITAL on 27/05/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit

class PostsTableViewController: UITableViewController, OpenImageURLDelegate{
    
    private var cellId = "PostCell"
    private var loaderCellId = "loaderCell"
    private var postListViewModel = PostListViewModel()
    private var initialEffect: Bool = false
    private var key = ""
    var isUpdating: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        configureNavigationBar()
        configureRefreshControl()
        populateData()
    }
    
    private func registerCells(){
        tableView.register(PostCell.self, forCellReuseIdentifier: cellId)
        tableView.register(LoaderCell.self, forCellReuseIdentifier: loaderCellId)
    }
    
    
    private func populateData(showLoader: Bool = true, appendData: Bool = false){
        if showLoader{
            self.tableView.showLoader()
        }
        
        DispatchQueue.main.async {
            let postsResource = self.postListViewModel.getPosts(key: self.key)
            WebService().load(resource: postsResource!){[weak self] result in
                if (self?.refreshControl!.isRefreshing)!{
                    self?.refreshControl?.endRefreshing()
                }
                if let redditData = result{
                    if appendData{
                        self?.postListViewModel.postViewModels.append(contentsOf: redditData.data.children.map(PostViewModel.init))
                    }else{
                        self?.postListViewModel.postViewModels = redditData.data.children.map(PostViewModel.init)
                    }
                    
                    self?.key = redditData.data.after!
                    if showLoader{
                        self?.tableView.restore(showSingleLine: true)
                    }
                    self?.updateData()
                    self?.isUpdating = false

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
        self.navigationController?.navigationBar.sizeToFit()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Reddit posts"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAll))
    }
    
    @objc private func deleteAll(){
        self.postListViewModel.restorePosts()
        self.updateData()
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
        key = ""
        populateData(showLoader: false)
    }
    
    //MARK: TABLEVIEW METHODS
    func openImage(cell: PostCell) {
        if let post = cell.post, let url = post.url{
            UIApplication.shared.open(URL(string: url)!)
        }
    }
    
    func downloadImage(cell: PostCell) {
        Tools.feedback()
        let alert = UIAlertController(title: "Save image ?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            
            if let url = URL(string: cell.post!.url!),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.showToast(message: "Image saved", seconds: 2.0)
            }else{
                self.showToast(message: "Image doesn't exists", seconds: 2.0)
            }
            
        }))

        self.present(alert, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postListViewModel.postViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostCell
        
        let vm = self.postListViewModel.postViewModels[indexPath.row]
        cell.delegate = self
        cell.postTableView = self
        cell.postImageView.image = nil
        cell.post = vm!.children.post
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PostCell else{
            return
        }
        cell.statusLabel.text = "Read"
        cell.statusLabel.textColor = .green
        self.postListViewModel.postViewModels[indexPath.row]!.children.post.status = true
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            self.postListViewModel.postViewModels.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        
        if distanceFromBottom < height {
            
            if !self.isUpdating{
                self.isUpdating = true
                self.populateData(showLoader: false, appendData: true)
            }
                
            
        }
        
    }
    
}
