//
//  Functions.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import UIKit

    /// 将一个类对象传入 configure函数，经过配置返回该对象
    /// - Returns: <#description#>
func configure<T: AnyObject>(_ object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}

/// 打印日志
func printLog(_ items: Any...,
              file: String = #file,
              function: String = #function,
              line: Int = #line) {
    #if DEBUG
    // 获取当前时间
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let timestamp = dateFormatter.string(from: Date())
    
    // 提取文件名（不含路径）
    let fileName = (file as NSString).lastPathComponent
    
    // 拼接前缀信息
    let prefix = "🕒 \(timestamp) | 📁 \(fileName) | ⚙️ \(function) | 📌 \(line):"
    
    // 打印完整日志
    print(prefix, items)
    #endif
}
