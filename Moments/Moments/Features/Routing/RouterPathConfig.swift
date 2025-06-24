//
//  RouterPathConfig.swift
//  Moments
//
//  Created by wjw on 2025/6/23.
//

import Foundation

//待注册路由 声明为枚举，避免多处使用硬编码
enum routerPath: String {
    case InternalMenu = "InternalMenu"
    case DesignKit = "DesignKit"
    case LoginView = "LoginView"
    case RegisterView = "RegisterView"
    case ForgotPasswordView = "ForgotPasswordView"
    case RootNavigationController = "RootNavigationController"
}
