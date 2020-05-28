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
                    
                    self?.postListViewModel.addloaderObject()
                    self?.key = redditData.data.after!
                    self?.tableView.restore(showSingleLine: true)
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
        populateData(showLoader: false)
    }
    
    //MARK: TABLEVIEW METHODS
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postListViewModel.postViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let vm = self.postListViewModel.postViewModels[indexPath.row]{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostCell
            cell.postTableView = self
            cell.postImageView.image = nil
            cell.post = vm.children.post
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: loaderCellId, for: indexPath) as! LoaderCell
            self.postListViewModel.removeLastPost()
            self.populateData(showLoader: false, appendData: true)
            return cell
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
            /*if !self.isUpdating{
                self.isEditing = true
                self.postListViewModel.removeLastPost()
                self.populateData(showLoader: false)
            }*/
            /*if !self.nextPage.isEmpty{
                if !self.isUpdating{
                    self.isUpdating = true
                    if Tools.hasInternet(){
                        self.characterListViewModel.charactersViewModel.removeLast()
                        self.populateCharacters(nextPage: nextPage)
                    }else{
                        showAlertNoWifi()
                    }
                    
                }
                
            }*/
        }
        
    }
    
    // MARK: Animation
    let blackBackgroundView = UIView()
    let viewImage = UIImageView()
    let navBarCover = UIView()
    let tabBarCover = UIView()
    
    var imageView: UIImageView?
    
    func animateImageView(imageView: UIImageView){
        
        self.imageView = imageView
    
        if  let startingFrame = imageView.superview?.convert(imageView.frame, to: nil){
            
            imageView.alpha = 0.0
            blackBackgroundView.frame = view.frame
            blackBackgroundView.backgroundColor = .black
            blackBackgroundView.alpha = 0.0
            view.addSubview(blackBackgroundView)
            
            navBarCover.frame = CGRectMake(0, 0, 1000, 147)
            navBarCover.backgroundColor = .black
            navBarCover.alpha = 0.0
            
            if let keyWindow = UIApplication.shared.keyWindow{
                keyWindow.addSubview(navBarCover)
                
                tabBarCover.frame = CGRectMake(0, keyWindow.frame.height - 50, 1000, 50)
                tabBarCover.backgroundColor = .black
                tabBarCover.alpha = 0.0
                keyWindow.addSubview(tabBarCover)
            }
            
            viewImage.backgroundColor = .red
            viewImage.frame = startingFrame
            viewImage.isUserInteractionEnabled = true
            viewImage.image = imageView.image
            viewImage.contentMode = .scaleToFill
            viewImage.clipsToBounds = true
            view.addSubview(viewImage)
            
            navBarCover.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(zoomOut)))
            blackBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(zoomOut)))
            viewImage.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action:#selector(zoomOut)))

            UIView.animate(withDuration: 0.75, animations: {
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                let y = self.view.frame.height / 2 - height / 2
                self.viewImage.frame = self.CGRectMake(0, y, self.view.frame.width, height)
                self.blackBackgroundView.alpha = 1.0
                self.navBarCover.alpha = 1.0
                self.tabBarCover.alpha = 1.0
            })
        }
        
    }
    
    @objc func zoomOut(){
        if  let startingFrame = imageView!.superview?.convert(imageView!.frame, to: nil){
            
            UIView.animate(withDuration: 0.75, animations: {
                self.viewImage.frame = startingFrame
                self.blackBackgroundView.alpha = 0.0
                self.navBarCover.alpha = 0.0
                self.tabBarCover.alpha = 0.0
            }, completion: { (true) in
                self.viewImage.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCover.removeFromSuperview()
                self.tabBarCover.removeFromSuperview()
                self.imageView?.alpha = 1.0
            })
        }
    }
    
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
}
