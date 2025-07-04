//
//  SceneDelegate.swift
//  Moments
//
//  Created by wjw on 2024/4/8.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    public var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // 1. 确保 scene 是 UIWindowScene 类型
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // 2. 初始化窗口并与场景关联
        window = UIWindow(windowScene: windowScene)
        // 在 AppDelegate 或 SceneDelegate 中设置
        window?.backgroundColor = .red
        window?.frame = windowScene.coordinateSpace.bounds
        print("H:Q", window?.frame.height ?? 0, " ", window?.frame.width ?? 0)
        // 3. 创建根视图控制器
        let rootViewController = LoginViewController()//AuthViewController()//MyInfoViewController(userId:  "1")////RootNavigationController()
        
        // 4. 将根控制器分配给窗口
        window?.rootViewController = rootViewController
        
        // 是否在cesium
//        if UIApplication.shared.isRunningUnitTests {
//            window?.rootViewController = UnitTestViewController()
//        } else {
//            window?.rootViewController = MomentsTimelineViewController()
//        }
        // 5. 显示窗口
        window?.makeKeyAndVisible()
        
        // Handle Universal Links here if already opt into Scenes
        if let userActivity = connectionOptions.userActivities.first,
            userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL {
            let router: AppRouting = AppRouter.shared
            router.route(to: incomingURL, from: nil, using: .present)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}
