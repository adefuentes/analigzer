//
//  IGUserViewController.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 03/12/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class IGUserViewController: UIViewController {

    public var userData: IGUserModel! {
        didSet {
            let count = userData.graphql?.user?.edge_owner_to_timeline_media?.edges?.count ?? 0
            let height: CGFloat = (CGFloat(count / 3) * ((view.frame.width / 3) - 4)) + 110
            heightConstraint.constant = height
        }
    }
    
    private var userController: IGGetUser!
    private var headerProfile: IGHeaderProfileView!
    private var mediaCollection: UICollectionView!
    private var heightConstraint: NSLayoutConstraint!
    private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userController = IGGetUser()
        userController.delegate = self
        
        setupViews()
        headerProfile.userData = userData
        navigationItem.title = "@\(userData.graphql?.user?.username ?? "")"
        
    }

}

extension IGUserViewController: IGGetUserDelegate {
    
    func getUser(withSuccess success: IGUserModel) {
        
        self.userData = success
        scrollView.dg_stopLoading()
        
    }
    
    func getUser(withPrimal primalData: IGPrimalModel) {
        // NOT USED
    }
    
    func getUser(withError error: String) {
        
        let alert = UIAlertController(title: "Oh oh!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension IGUserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userData.graphql?.user?.edge_owner_to_timeline_media?.edges?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? IGMediaCell else {
            return UICollectionViewCell()
            
        }
        
        let media = userData.graphql?.user?.edge_owner_to_timeline_media?.edges?[indexPath.row]
        
        cell.mediaImageView.downloaded(from: media?.node?.display_url ?? "")
        cell.mediaImageView.contentMode = .scaleAspectFill
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width/3 - 4, height: collectionView.frame.width/3 - 4)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 60, left: 3, bottom: 0, right: 3)
    }
    
}

extension IGUserViewController {
    func setupViews() {
        
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        
        let layout = UICollectionViewFlowLayout()
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 380))
        backgroundView.backgroundColor = .white
        
        scrollView = UIScrollView(frame: view.frame)
        
        headerProfile = IGHeaderProfileView()
        headerProfile.backgroundColor = .clear
        
        mediaCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mediaCollection.backgroundColor = UIColor(white: 0.97, alpha: 1)
        mediaCollection.register(IGMediaCell.self, forCellWithReuseIdentifier: "mediaCell")
        mediaCollection.dataSource = self
        mediaCollection.delegate = self
        mediaCollection.isScrollEnabled = false
        
        headerProfile.translatesAutoresizingMaskIntoConstraints = false
        mediaCollection.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        scrollView.addSubview(mediaCollection)
        scrollView.addSubview(headerProfile)
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.black
        scrollView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            self?.userController.getUser(user: self?.userData.graphql?.user?.username ?? "")
            
        }, loadingView: loadingView)
        scrollView.dg_setPullToRefreshFillColor(UIColor(white: 0.97, alpha: 1))
        scrollView.dg_setPullToRefreshBackgroundColor(.white)
        
        scrollView.addConstraintsWithFormat(visualFormat: "V:|-8-[v0(400)][v1]-16-|", views: headerProfile, mediaCollection)
        
        headerProfile.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerProfile.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mediaCollection.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mediaCollection.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        heightConstraint = NSLayoutConstraint(item: mediaCollection,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .height,
                                              multiplier: 1,
                                              constant: 1)
        
        scrollView.addConstraint(heightConstraint)
        
    }
}

class IGMediaCell: UICollectionViewCell {
    
    public var mediaImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mediaImageView = {
           
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            return imageView
            
        }()
        
        mediaImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mediaImageView)
        
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: mediaImageView)
        addConstraintsWithFormat(visualFormat: "V:|[v0]|", views: mediaImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class IGHeaderProfileView: UIView {
    
    public var userData: IGUserModel! {
        didSet {
            fillViews()
        }
    }
    
    var picProfileView: UIImageView!
    var fullnameLabel: UILabel!
    var locationLabel: UILabel!
    var uriLabel: UILabel!
    var biographyLabel: UILabel!
    var followersLabel: UILabel!
    var followedLabel: UILabel!
    var postLabel: UILabel!
    var followButton: UIButton!
    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension IGHeaderProfileView {
    
    func fillViews() {
        
        let followed_by = userData.graphql?.user?.edge_followed_by?.count ?? 0
        let follow = userData.graphql?.user?.edge_follow?.count ?? 0
        let post = userData.graphql?.user?.edge_owner_to_timeline_media?.count ?? 0
        
        var followed_byString = "\(followed_by)"
        var followString = "\(follow)"
        var postString = "\(post)"
        
        if followed_by >= 10000 {
            
            if followed_by >= 1000000 {
                followed_byString = "\(followed_byString.prefix(5)) mill."
            } else {
                followed_byString = "\(followed_byString.prefix(2))k"
            }
            
        }
        
        if follow >= 10000 {
            
            if follow >= 1000000 {
                followString = "\(followString.prefix(5)) mill."
            } else {
                followString = "\(followString.prefix(2))k"
            }
            
        }
        
        if post >= 10000 {
            
            if post >= 1000000 {
                postString = "\(postString.prefix(5)) mill."
            } else {
                postString = "\(postString.prefix(2))k"
            }
            
        }
        
        var attributedText = NSMutableAttributedString(string: "\(followed_byString)\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "Seguidores", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        followersLabel.attributedText = attributedText
        
        attributedText = NSMutableAttributedString(string: "\(followString)\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "Seguidos", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        followedLabel.attributedText = attributedText
        
        attributedText = NSMutableAttributedString(string: "\(postString)\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "Publicaciones", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        postLabel.attributedText = attributedText
        
        picProfileView.downloaded(from: userData.graphql?.user?.profile_pic_url ?? "")
        fullnameLabel.text = userData.graphql?.user?.full_name ?? ""
        locationLabel.text = "@\(userData.graphql?.user?.username ?? "")"
        uriLabel.text = userData.graphql?.user?.external_url ?? ""
        biographyLabel.text = userData.graphql?.user?.biography ?? ""
        
        if userData.graphql?.user?.follows_viewer ?? false {
            followButton.setTitle("Seguir", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = UIColor(red: 112/255, green: 166/255, blue: 211/255, alpha: 1)
        } else {
            followButton.setTitle("Siguiendo", for: .normal)
            followButton.setTitleColor(.black, for: .normal)
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.black.cgColor
            followButton.backgroundColor = .white
        }
        
    }
    
    func buildViews() {
        
        picProfileView = {
           
            let imageView = UIImageView()
            imageView.layer.cornerRadius = 40
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            return imageView
            
        }()
        fullnameLabel = {
           
            let label = UILabel()
            
            label.textAlignment = .center
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            
            return label
            
        }()
        locationLabel = {
            
            let label = UILabel()
            
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16, weight: .light)
            label.textColor = .lightGray
            
            return label
            
        }()
        uriLabel = {
            
            let label = UILabel()
            
            label.textAlignment = .center
            label.textColor = UIColor(red: 112/255, green: 166/255, blue: 211/255, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 16, weight: .light)
            
            return label
            
        }()
        biographyLabel = {
            
            let label = UILabel()
            
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 20
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont.systemFont(ofSize: 16, weight: .light)
            
            return label
            
        }()
        followersLabel = {
            
            let label = UILabel()
            
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 2
            label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            
            return label
            
        }()
        followedLabel = {
            
            let label = UILabel()
            
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 2
            label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            
            return label
            
        }()
        postLabel = {
            
            let label = UILabel()
            
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 2
            label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            
            return label
            
        }()
        followButton = {
           
            let button = UIButton()
            
            button.layer.cornerRadius = 20
            
            return button
            
        }()
        
        stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(postLabel)
        stackView.addArrangedSubview(followersLabel)
        stackView.addArrangedSubview(followedLabel)
        
        picProfileView.translatesAutoresizingMaskIntoConstraints = false
        fullnameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        uriLabel.translatesAutoresizingMaskIntoConstraints = false
        biographyLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(picProfileView)
        addSubview(fullnameLabel)
        addSubview(locationLabel)
        addSubview(uriLabel)
        addSubview(biographyLabel)
        addSubview(stackView)
        addSubview(followButton)
        
    }
    
    func setupViews() {
        
        buildViews()
        
        addConstraintsWithFormat(visualFormat: "V:|-[v0(80)]-16-[v1(20)]-[v2(20)]-[v3(20)]-16-[v4]-16-[v5(60)]-16-[v6(40)]-|", views: picProfileView, fullnameLabel, locationLabel, uriLabel, biographyLabel, stackView, followButton)
        
        addConstraintsWithFormat(visualFormat: "H:[v0(80)]", views: picProfileView)
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: fullnameLabel)
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: locationLabel)
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: uriLabel)
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: biographyLabel)
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: stackView)
        addConstraintsWithFormat(visualFormat: "H:[v0(250)]", views: followButton)
        
        centerWithConstraints(picProfileView)
        centerWithConstraints(followButton)
        
        
    }
    
}
