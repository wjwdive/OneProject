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
