//
//  UIApplicationExtensions.swift
//  Moments
//
//  Created by wjw on 2025/5/24.
//

import UIKit

extension UIApplication {
    var rootViewController: UIViewController? {
            //这是 UIApplication 的属性，表示当前 app 的所有场景（Scene，通常指多个窗口，比如 iPad 支持多窗口）。
        let keyWindow = connectedScenes
            //过滤出激活状态为“前台活跃”（foregroundActive）的场景。也就是正在显示、用户可见的窗口。
                .filter({ $0.activationState == .foregroundActive })
            //将每个 Scene 转换为 UIWindowScene（iOS 13+ 场景支持，窗口级别的 Scene）。
            //不是 UIWindowScene 的会变成 nil。
                .map({ $0 as? UIWindowScene })
            //过滤掉 nil，得到有效的 UIWindowScene
                .compactMap({ $0 })
            //取第一个有效的 UIWindowScene，然后访问它的 windows 属性，得到所有窗口。
                .first?.windows
            //过滤出主窗口（isKeyWindow），也就是当前 app 的主窗口。
                .first(where: { $0.isKeyWindow })
            //返回 keyWindow 的根视图控制器
        return keyWindow?.rootViewController
    }
    /// 获取当前应用的版本号
    static var appVersion: String {
        // swiftlint:disable no_hardcoded_strings
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        // swiftlint:enable no_hardcoded_strings
    }
    
    /// 判断当前是否处于单元测试状态
    var isRunningUnitTests: Bool {
        // swiftlint:disable no_hardcoded_strings
        return NSClassFromString("XCTestCase") != nil
        // swiftlint:enable no_hardcoded_strings
    }
}
