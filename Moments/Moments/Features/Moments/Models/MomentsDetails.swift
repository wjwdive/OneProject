//
//  MomentsDetails.swift
//  Moments
//
//  Created by wjw on 2025/5/26.
//

import Foundation

struct MomentsDetails: Codable {
    let userDetails: UserDetails
    let moments: [Moment]
    
    struct UserDetails: Codable {
        let userId: String
        let name: String
        let avatar: String
        let backgroundImage: String
    }
    
    struct Moment: Codable {
        let id: String
        let userDetials: MomentsUserDetails
        let type: MomentType
        let title: String!
        let url: String?
        let photo: [String]
        let createdDate: String 
        let isLiked: Bool? // Change to non-optional when removing `isLikeButtonForMomentEnabled` toggle
        let likes: [LikedUserDetails]?  // Change to non-optional when removing `isLikeButtonForMomentEnabled` toggle
    }
    
    struct MomentsUserDetails: Codable {
        let userId: String
        let avatar: String
    }
    
    struct LikedUserDetails: Codable {
        let id: String
        let avatar: String
    }
    
    //swiftlint:disable no_hardcoded_strings
    enum MomentType: String, Codable {
        case url = "URL"
        case photo = "PHOTOS"
    }
    //swiftlint:enable no_hardcoded_strings

}
