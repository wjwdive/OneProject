//
//  AppError.swift
//  Moments
//
//  Created by wjw on 2025/6/25.
//

import Foundation
//定义统一的错误处理，网络层错误，数据解析错误，业务层错误。
struct AppError: Error {
    let code: Int         // 自定义错误码（网络错误为负数，业务错误为正数）
    let message: String   // 用户友好的错误消息
    let errorDetail: String  // 详细错误信息（供开发者调试）
    
    // 预定义错误类型
    static let networkError = AppError(
        code: -1,
        message: "网络连接失败，请检查网络",
        errorDetail: "网络连接异常"
    )
    
    static let decodingError = AppError(
        code: -2,
        message: "数据解析失败",
        errorDetail: "响应数据格式错误"
    )
    
    static func serverError(statusCode: Int, detail: String) -> AppError {
        return AppError(
            code: -100 - statusCode,
            message: "服务器错误 (\(statusCode))",
            errorDetail: detail
        )
    }
    
    static func businessError(code: Int, message: String, detail: String) -> AppError {
        return AppError(
            code: code,
            message: message,
            errorDetail: "业务错误 \(code): \(detail)"
        )
    }
}

// 扩展AppError添加详情
extension AppError {
    func withDetail(_ detail: String) -> AppError {
        return AppError(code: self.code, message: self.message, errorDetail: detail)
    }
}

// 扩展 Error 协议以便转换
extension Error {
    func asAppError() -> AppError {
        if let appError = self as? AppError {
            return appError
        }
        return AppError(
            code: -999,
            message: self.localizedDescription,
            errorDetail: "未处理错误: \(self)"
        )
    }
}
