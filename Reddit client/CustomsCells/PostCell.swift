//
//  PostCell.swift
//  Reddit client
//
//  Created by beTech CAPITAL on 27/05/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation
import UIKit

class PostCell: UITableViewCell{
    
    var postTableView : PostsTableViewController?

    var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var entryLalbel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.font = label.font.withSize(10)
        return label
    }()
    
    var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.font = label.font.withSize(10)
        label.textColor = .gray
        return label
    }()
    
    var infoStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .fillEqually // .fillEqually .fillProportionally .equalSpacing .equalCentering
        return stackView
    }()
    
    var commentsStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var statusStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    var commentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var commentsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.text = " #Comments"
        return label
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .orange
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var statusTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.text = "Status"
        return label
    }()
    
    var post: Post? {
        didSet{
            titleLabel.text = post?.title
            entryLalbel.text = "Entry"
            if let post = post, let author = post.author_fullname{
                authorLabel.text = "by: " + author
            }
            commentsLabel.text = post?.num_comments?.description
            statusLabel.text = "Unread"
        
            if let post = post, let image = post.url{
                Tools.downloadImage(url: URL(string: image)!) { (image, error) in
                    DispatchQueue.main.async {
                        if error == nil {
                            self.postImageView.image = image
                        }else{
                            self.postImageView.image = UIImage(named: "notfound")
                        }
                    }
                }
            }else{
                self.postImageView.image = UIImage(named: "notfound")
            }
            
            if let post = post, let time = post.created_utc{
                let date = Date(timeIntervalSince1970: time)
                entryLalbel.text = date.timeAgo()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(postImageView)
        addSubview(infoStackView)
        
        
        postImageTapHandler()
        configCommentsStackView()
        configStatusStackView()
        configStackView()
        configBottomStackView()
        setConstraintsImageView()
        setConstraintStackView()
    }
    
    private func postImageTapHandler(){
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(animate)))
    }
    
    @objc func animate(){
        postTableView?.animateImageView(imageView: postImageView)
    }
    
    private func configStatusStackView(){
        statusStackView.addArrangedSubview(statusTitleLabel)
        statusStackView.addArrangedSubview(statusLabel)
    }
    
    private func configCommentsStackView(){
        commentsStackView.addArrangedSubview(commentsTitleLabel)
        commentsStackView.addArrangedSubview(commentsLabel)
    }
    
    private func configBottomStackView(){
        infoStackView.addArrangedSubview(bottomStackView)
        bottomStackView.addArrangedSubview(commentsStackView)
        bottomStackView.addArrangedSubview(statusStackView)
    }
    
    private func configStackView(){
        infoStackView.addArrangedSubview(entryLalbel)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(authorLabel)
    }
    
    private func setConstraintStackView(){
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        infoStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        infoStackView.leadingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: 20).isActive = true
        infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    private func setConstraintAuthorLabel(){
        
    }
    
    private func setConstraintEntryLabel(){
        entryLalbel.translatesAutoresizingMaskIntoConstraints = false
        entryLalbel.leadingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: 20).isActive = true
        entryLalbel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        entryLalbel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        entryLalbel.heightAnchor.constraint(equalToConstant: 15).isActive = true

    }
    
    private func setConstraintsImageView(){
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        postImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func setConstraintsTitleLabel(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: entryLalbel.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
