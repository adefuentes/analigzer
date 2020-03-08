//
//  IGFollowedByModel.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 19/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation

struct IGOwner: Decodable {
    let __typename: String?
    let id: String?
    let profile_pic_url: String?
    let username: String?
}

struct IGReel: Decodable {
    let id: String?
    let expiring_at: Int?
    let latest_reel_media: Int?
    let seen: Int?
    let owner: IGOwner?
}

struct IGNode: Decodable {
    let id: String?
    let username: String?
    let full_name: String?
    let profile_pic_url: String?
    let is_private: Bool?
    let is_verified: Bool?
    let followed_by_viewer: Bool?
    let requested_by_viewer: Bool?
    let reel: IGReel?
}

struct IGPageInfo: Decodable {
    let has_next_page: Bool?
    let end_cursor: Bool?
}

struct IGEdge: Decodable {
    let node: IGNode?
}

struct IGEdges: Decodable {
    let count: Int?
    let page_info: IGPageInfo?
    let edges: [IGEdge]?
}

struct IGFollowedByModel: Decodable {
    
    struct IGUserFollowed: Decodable {
        let edge_followed_by: IGEdges?
        let edge_mutual_followed_by: IGEdges?
    }
    
    struct IGData: Decodable {
        let user: IGUserFollowed?
    }
    
    let data: IGData?
    let status: String?
    
}

struct IGFollowedModel: Decodable {
    
    struct IGUserFollowed: Decodable {
        let edge_follow: IGEdges?
        let edge_mutual_followed_by: IGEdges?
    }
    
    struct IGData: Decodable {
        let user: IGUserFollowed?
    }
    
    let data: IGData?
    let status: String?
    
}
