//
//  Configuration.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import Foundation

    /// 用途场景： 你可以用 Configuration.value(for: "某个key") 去获取 Info.plist 里的自定义配置项，比如 API 地址、开关、ID 等，保证类型安全且易于维护。
    /// 这样做的好处是，所有 Info.plist 的读取都集中管理、集中处理异常，代码更加安全和整洁。
    /// 用法示例：
    /// let apiBaseURL: String = try Configuration.value(for: "APIBaseURL")
    /// let version: Int = try Configuration.value(for: "AppVersion")
enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}
