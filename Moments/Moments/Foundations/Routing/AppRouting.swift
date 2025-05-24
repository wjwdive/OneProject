//
//  AppRouting.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import Foundation
import UIKit

    /// 定义路由协议，里面有注册方法，路由方法
protocol AppRouting {
    func register(path: String, navigator: Navigating)
    func route(to url: URL?, from routingSource: RoutingSource?, using transitionType: TransitionType)
}
