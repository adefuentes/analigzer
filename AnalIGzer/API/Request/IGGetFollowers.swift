//
//  IGGetFollowers.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 20/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation

protocol IGFollowersDelegate {
    func followers(_ success: IGFollowedByModel)
    func followers(_ success: IGFollowedModel)
    func followers(_ error: String)
}

class IGFollowers {
    public var delegate: IGFollowersDelegate?
    
    private let kGET_FOLLOWERS = "https://www.instagram.com/graphql/query/?query_hash=56066f031e6239f35a904ac20c9f37d9&variables=%7B%22id%22%3A%229257777179%22%2C%22include_reel%22%3Atrue%2C%22fetch_mutual%22%3Atrue%2C%22first%22%3A24%7D"
    private let kGET_FOLLOWED = "https://www.instagram.com/graphql/query/?query_hash=c56ee0ae1f89cdbd1c89e2bc6b8f3d18&variables=%7B%22id%22%3A%229257777179%22%2C%22include_reel%22%3Atrue%2C%22fetch_mutual%22%3Afalse%2C%22first%22%3A24%7D"
    
    enum followType {
        case followers
        case followed
    }
    
    func getFollowedBy(_ type: IGFollowers.followType) {
        
        var path = ""
        
        switch type {
        case .followed:
            path = kGET_FOLLOWED
            break
        case .followers:
            path = kGET_FOLLOWERS
            break
        }
        
        guard let url = URL(string: path) else {
            return
        }
        var uri = URLRequest(url: url)
        
        uri.addValue(IGSavedData.cookies, forHTTPHeaderField: "cookie")
        
        let task = URLSession.shared.dataTask(with: uri) { (data, urlResponse, error) in
            
            guard let response = data else { return }
            guard error == nil else { return }
            
            print(String(data: response, encoding: .utf8) ?? "No data")
            
            do {
                let decoder = JSONDecoder()
                switch type {
                case .followed:
                    let followed = try decoder.decode(IGFollowedModel.self, from: response)
                    
                    DispatchQueue.main.async {
                        self.delegate?.followers(followed)
                    }
                    break
                case .followers:
                    let followedBy = try decoder.decode(IGFollowedByModel.self, from: response)
                    
                    DispatchQueue.main.async {
                        self.delegate?.followers(followedBy)
                    }
                    break
                }
                
                
            } catch let err {
                
                DispatchQueue.main.async {
                    self.delegate?.followers(err.localizedDescription)
                }
                
            }
            
        }
        task.resume()
        
    }
}
