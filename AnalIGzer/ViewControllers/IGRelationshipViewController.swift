//
//  IGRelationshipTableViewController.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 23/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit
import SwiftInstagram

class IGRelationshipViewController: UITableViewController {

    var edges: IGEdges?
    var type: IGFollowers.followType!
    
    let controller = IGGetUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controller.delegate = self
        
        navigationItem.title = (type == .followers) ? "Seguidores" : "Seguidos"
        
        tableView.register(IGProfileTableCell.self, forCellReuseIdentifier: "profileCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
    }

}

extension IGRelationshipViewController: IGGetUserDelegate {
    
    func getUser(withSuccess success: IGUserModel) {
        let viewController = IGUserViewController()
        viewController.userData = success
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getUser(withPrimal primalData: IGPrimalModel) {
        // NOT USED
    }
    
    func getUser(withError error: String) {
        let alert = UIAlertController(title: "Oh oh!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
}

extension IGRelationshipViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return edges?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? IGProfileTableCell else {
            return UITableViewCell()
        }
        cell.type = self.type
        cell.edge = edges?.edges?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let edge = edges?.edges?[indexPath.row]
        controller.getUser(user: edge?.node?.username ?? "")
    }
    
}

class IGProfileTableCell: UITableViewCell {
    
    let profileImage = UIImageView()
    let nameProfile = UILabel()
    let usernameProfile = UILabel()
    let interactiveButton = UIButton()
    var collection: UICollectionView!
    var type: IGFollowers.followType!
    var edge: IGEdge? {
        didSet {
            parse()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        
        usernameProfile.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        usernameProfile.textColor = .lightGray
        
        interactiveButton.layer.cornerRadius = 5
        interactiveButton.layer.borderColor = UIColor.darkGray.cgColor
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        nameProfile.translatesAutoresizingMaskIntoConstraints = false
        usernameProfile.translatesAutoresizingMaskIntoConstraints = false
        interactiveButton.translatesAutoresizingMaskIntoConstraints = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(profileImage)
        addSubview(nameProfile)
        addSubview(usernameProfile)
        addSubview(interactiveButton)
        addSubview(collection)
        
        addConstraintsWithFormat(visualFormat: "H:|-[v0(60)]-[v1]-[v2(100)]-|", views: profileImage, nameProfile, interactiveButton)
        addConstraintsWithFormat(visualFormat: "H:[v0]-[v1]-[v2]", views: profileImage, usernameProfile, interactiveButton)
        addConstraintsWithFormat(visualFormat: "V:|-[v0(60)]-[v1]-|", views: profileImage, collection)
        addConstraintsWithFormat(visualFormat: "V:|-[v0][v1(20)]", views: nameProfile, usernameProfile)
        
        addConstraint(NSLayoutConstraint(item: interactiveButton,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: profileImage,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0))
        
    }
    
    func parse() {
        
        profileImage.downloaded(from: edge?.node?.profile_pic_url ?? "", contentMode: .scaleAspectFill)
        nameProfile.text = edge?.node?.full_name
        usernameProfile.text = "@\(edge?.node?.username ?? "")"
        interactiveButton.backgroundColor = (edge?.node?.followed_by_viewer ?? false) ? .clear : kPALETTE_COLORS[1].withAlphaComponent(0.9)
        interactiveButton.setTitle((edge?.node?.followed_by_viewer ?? false) ? "Siguiendo" : "Seguir", for: .normal)
        interactiveButton.setTitleColor((edge?.node?.followed_by_viewer ?? false) ? .darkGray : .white, for: .normal)
        interactiveButton.layer.borderWidth = (edge?.node?.followed_by_viewer ?? false) ? 1 : 0
        
        let isPrivate = edge?.node?.is_private ?? false
        
        collection.isHidden = isPrivate
        
        if isPrivate { return }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
