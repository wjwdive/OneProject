import Foundation

struct Contact {
    let id: String
    let name: String
    let avatar: String?
    let phone: String?
    let email: String?
    let department: String?
    let position: String?
    
    // 用于分组显示的拼音首字母
    var pinyinInitial: String {
        // TODO: 实现拼音转换
        return String(name.prefix(1))
    }
} 