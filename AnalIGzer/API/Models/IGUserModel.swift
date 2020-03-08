//
//  File.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 27/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation

struct IGPrimalModel: Decodable {
    
    struct IGEdgeSuggestedUsers: Decodable {
        let count: Int?
    }
    
    struct IGEdgeChaining: Decodable {
        let count: Int?
    }
    
    struct IGUserData: Decodable {
        let id: String?
        let profile_pic_url: String?
        let username: String?
    }
    
    struct IGOwner: Decodable {
        let __typename: String?
        let id: String?
        let profile_pic_url: String?
        let username: String?
    }
    
    struct IGReel: Decodable {
        let __typename: String?
        let id: String?
        let expiring_at: Int?
        let latest_reel_media: Bool?
        let seen: Bool?
        let user: IGUserData?
        let owner: IGOwner?
    }
    
    struct IGNode: Decodable {
        let id: String?
        let blocked_by_viewer: Bool?
        let followed_by_viewer: Bool?
        let follows_viewer: Bool?
        let full_name: String?
        let has_blocked_viewer: Bool?
        let has_requested_viewer: Bool?
        let is_private: Bool?
        let is_verified: Bool?
        let profile_pic_url: String?
        let requested_by_viewer: Bool?
        let username: String?
    }
    
    struct IGEdge: Decodable {
        let node: IGNode?
    }
    
    struct IGUser: Decodable {
        let reel: IGReel?
        let edge_chaining: IGEdgeChaining?
    }
    
    struct IGViewer: Decodable {
        let edge_suggested_users: IGEdgeSuggestedUsers?
    }
    
    struct IGData: Decodable {
        let viewer: IGViewer?
        let user: IGUser?
    }
    
    let data: IGData?
    let status: String?
    
}

struct IGDimensions: Decodable {
    let height: Float?
    let width: Float?
}

struct IGLocation: Decodable {
    let id: String?
    let has_public_page: Bool?
    let name: String?
    let slug: String?
}

struct IGOwner_Media: Decodable {
    let id: String?
    let username: String?
}

struct IGResource: Decodable {
    let src: String?
    let config_width: Float?
    let config_height: Float?
}

struct IGUserModel: Decodable {
    
    struct IGEdge_Follow: Decodable {
        let count: Int?
    }
    
    struct IGEdge_Mutual: Decodable {
        let count: Int?
        let edges: [IGEdge] = []
    }
    
    struct IGPage_Info: Decodable {
        let has_next_page: Bool?
        let end_cursor: String?
    }
    
    struct IGNode_Media: Decodable {
        let text: String?
    }
    
    struct IGEdge_Media: Decodable {
        let node: IGNode_Media?
    }
    
    struct IGEdges_Media: Decodable {
        let edge: [IGEdge_Media]?
    }
    
    struct IGNode: Decodable {
        let __typename: String?
        let id: String?
        //let edge_media_to_caption: [IGEdges_Media]?
        let shortcode: String?
        let edge_media_to_comment: IGEdge_Follow?
        let comments_disabled: Bool?
        let taken_at_timestamp: Int?
        let dimensions: IGDimensions?
        let display_url: String?
        let edge_liked_by: IGEdge_Follow?
        let edge_media_preview_like: IGEdge_Follow?
        let location: IGLocation?
        let gating_info: String?
        let media_preview: String?
        let owner: IGOwner_Media?
        let thumbnail_src: String?
        let thumbnail_resources: [IGResource]?
        let is_video: Bool?
        let accessibility_caption: String?
    }
    
    struct IGEdge: Decodable {
        let node: IGNode?
    }
    
    struct IGEdge_Felix: Decodable {
        let count: Int?
        let page_info: IGPage_Info?
        let edges: [IGEdge]?
    }
    
    struct IGOnboarding_Video: Decodable {
        let mp4: String?
        let poster: String?
    }
    
    struct IGUser: Decodable {
        let biography: String?
        let blocked_by_viewer: Bool?
        let country_block: Bool?
        let external_url: String?
        let external_url_linkshimmed: String?
        let edge_followed_by: IGEdge_Follow?
        let followed_by_viewer: Bool?
        let edge_follow: IGEdge_Follow?
        let follows_viewer: Bool?
        let full_name: String?
        let has_channel: Bool?
        let has_blocked_viewer: Bool?
        let highlight_reel_count: Int?
        let has_requested_viewer: Bool?
        let id: String?
        let is_business_account: Bool?
        let is_joined_recently: Bool?
        let business_category_name: String?
        let business_email: String?
        let business_phone_number: String?
        let business_address_json: String?
        let is_private: Bool?
        let is_verified: Bool?
        let edge_mutual_followed_by: IGEdge_Mutual?
        let profile_pic_url: String?
        let profile_pic_url_hd: String?
        let requested_by_viewer: Bool?
        let username: String?
        let connected_fb_page: Bool?
        let edge_felix_combined_post_uploads: IGEdge_Felix?
        let edge_felix_combined_draft_uploads: IGEdge_Felix?
        let edge_felix_video_timeline: IGEdge_Felix?
        let edge_felix_drafts: IGEdge_Felix?
        let edge_felix_pending_post_uploads: IGEdge_Felix?
        let edge_felix_pending_draft_uploads: IGEdge_Felix?
        let edge_owner_to_timeline_media: IGEdge_Felix?
        let edge_saved_media: IGEdge_Felix?
        let edge_media_collections: IGEdge_Felix?
    }
    
    struct IGGraphql: Decodable {
        let user: IGUser?
    }
    
    let logging_page_id: String?
    let show_suggested_profiles: Bool?
    let graphql: IGGraphql?
    let felix_onboarding_video_resources: IGOnboarding_Video?
    
}
