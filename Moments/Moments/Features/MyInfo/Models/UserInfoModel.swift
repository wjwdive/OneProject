import Foundation

struct UserInfoModel: Codable, Equatable {
    let userId: Int
    let username: String
    let avatarUrl: String?
    let createdAt: Date?
    let updatedAt: Date?
    let deletedAt: Date?
    let isDeleted: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username = "username"
        case avatarUrl = "avatar_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case isDeleted = "is_deleted"
    }
    
    init(userId: Int, username: String, avatarUrl: String?, createdAt: Date?, updatedAt: Date?, deletedAt: Date?, isDeleted: Int) {
        self.userId = userId
        self.username = username
        self.avatarUrl = avatarUrl
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.isDeleted = isDeleted
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(Int.self, forKey: .userId)
        username = try container.decode(String.self, forKey: .username)
        avatarUrl = try container.decodeIfPresent(String.self, forKey: .avatarUrl)
        isDeleted = try container.decode(Int.self, forKey: .isDeleted)
        
        // 使用 ISO8601DateFormatter 解析日期
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt) {
            createdAt = dateFormatter.date(from: createdAtString)
        } else {
            createdAt = nil
        }
        
        if let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt) {
            updatedAt = dateFormatter.date(from: updatedAtString)
        } else {
            updatedAt = nil
        }
        
        if let deletedAtString = try container.decodeIfPresent(String.self, forKey: .deletedAt) {
            deletedAt = dateFormatter.date(from: deletedAtString)
        } else {
            deletedAt = nil
        }
    }
}

extension UserInfoModel {
    static func == (lhs: UserInfoModel, rhs: UserInfoModel) -> Bool {
        return lhs.userId == rhs.userId &&
               lhs.username == rhs.username &&
               lhs.avatarUrl == rhs.avatarUrl &&
               lhs.createdAt == rhs.createdAt &&
               lhs.updatedAt == rhs.updatedAt &&
               lhs.deletedAt == rhs.deletedAt &&
               lhs.isDeleted == rhs.isDeleted
    }
} 
