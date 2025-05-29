//
//  MomentsDetails.swift
//  Moments
//
//  Created by wjw on 2025/5/26.
//

import Foundation

let json1 = """
"moments":[
{
"images":[
"https://example.com/images/park1.jpg",
"https://example.com/images/park2.jpg"
],
"content":"今天天气真好，去公园散步了！",
"location":"中央公园",
"deleted_at":null,
"created_at":"2025-05-27T07:26:05.000Z",
"moment_id":1,
"username":"张三",
"user_id":1,
"is_deleted":0,
"updated_at":"2025-05-27T07:26:05.000Z",
"avatar_url":"https://example.com/avatars/zhangsan.jpg"
},
"""


struct MomentsDetails: Codable {
    let moments: MomentsData
    
    struct MomentsData: Codable {
        let moments: [Moment]
        let userDetail: UserDetail
    }
    
    struct UserDetail: Codable {
        let userId: Int
        let name: String
        let avatarURL: String?
//        let backgroundImageURL: String

        
        enum CodingKeys: String, CodingKey {
            case userId = "userId"
            case name = "username"
            case avatarURL = "avatar"
        }
    }
    
    struct Moment: Codable {
        let id: Int
        let userID: Int
        let name: String?
        let title: String
        let url: String?
        let photo: [String]?
        let createdDate: String 
        let isDeleted: Int
        let updatedAt: String
        let avatarUrl: String?
        let location: String
        let deletedAt: String?
        
        //添加了 userName 计算属性，它安全地处理 name 的可选值
        //如果 name 为 nil，则返回 "未知用户" 作为默认值
        //现在，您应该使用 moment.userName 而不是 String(moment.name)，这样可以避免强制解包导致的崩溃。
        var userName: String {
            return name ?? "未知用户"
        }
        
        enum CodingKeys: String, CodingKey {
            case id = "moment_id"
            case userID = "user_id"
            case name = "username"
            case title = "content"
            case url = "url"
            case photo = "images"
            case createdDate = "created_at"
            case isDeleted = "is_deleted"
            case updatedAt = "updated_at"
            case deletedAt = "deleted_at"
            case avatarUrl = "avatar_url"
            case location
        }
    }
    
//    struct MomentsUserDetails: Codable {
//        let userId: String
//        let avatar: String
//        let name: String
//
//        enum CodingKeys: String, CodingKey {
//            case userId = "userId"
//            case name = "name"
//            case avatar = "avatar"
//        }
//    }
    
//    struct LikedUserDetails: Codable {
//        let id: String
//        let avatar: String
//
//        enum CodingKeys: String, CodingKey {
//            case id = "userId"
//            case avatar = "avatar"
//        }
//    }
    
    //swiftlint:disable no_hardcoded_strings
//    enum MomentType: String, Codable {
//        case url = "URL"
//        case photo = "PHOTOS"
//    }
    //swiftlint:enable no_hardcoded_strings

}


/*
    // 顶层
    struct MomentsDetails: Codable {
        let success: Bool
        let data: MomentsData
    }

    struct MomentsData: Codable {
        let moments: [Moment]
        let userDetial: UserDetail
    }

    struct UserDetail: Codable {
        let name: String
        let avatar: String
        let backgroundImageURL: String
    }

    struct Moment: Codable {
        let images: [String]?        // 可以为 null，故为可选
        let content: String
        let location: String
        let deletedAt: String?       // 可为 null
        let createdAt: String
        let momentId: Int
        let username: String
        let userId: Int
        let isDeleted: Int
        let updatedAt: String
        let avatarUrl: String

        enum CodingKeys: String, CodingKey {
            case images
            case content
            case location
            case deletedAt = "deleted_at"
            case createdAt = "created_at"
            case momentId = "moment_id"
            case username
            case userId = "user_id"
            case isDeleted = "is_deleted"
            case updatedAt = "updated_at"
            case avatarUrl = "avatar_url"
        }
    }

*/
