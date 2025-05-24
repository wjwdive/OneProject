//
//  AppRouter.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import UIKit

final class AppRouter: AppRouting {
    static let shared: AppRouter = .init()

    private var navigators: [String: Navigating] = [:]

    private init() { }

    func register(path: String, navigator: Navigating) {
        navigators[path.lowercased()] = navigator
    }

    func route(to url: URL?, from routingSource: RoutingSource?, using transitionType: TransitionType = .present) {
        // UIApplication.shared.rootViewController 报错： Value of type 'UIApplication' has no member 'rootViewController'  AI: if let 判断适合 iOS 13 之前和之后，iOS 15之后又有API更新
        var rootWindow : UIViewController?
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let rootViewController = window.rootViewController {
            // 使用 rootViewController
            rootWindow = rootViewController
        }
        guard let url = url, let sourceViewController = routingSource as? UIViewController ?? rootWindow else { return }
        //从url里解析出url
        let path = url.lastPathComponent.lowercased()
        //获取URL的各个部分
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        //解析出url中的参数
        let parameters: [String: String] = (urlComponents.queryItems ?? []).reduce(into: [:]) { params, queryItem in
            params[queryItem.name.lowercased()] = queryItem.value
        }
        navigators[path]?.navigate(from: sourceViewController, using: transitionType, parameters: parameters)
    }
}
