//
//  AppDelegate.swift
//  Moments
//
//  Created by wjw on 2024/4/8.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

private extension AppDelegate {
    func onLaunch() {
        //Firebase 配置
        //FirebaseApp.configure()

        // Can register multiple tracking providers here
//        [FirebaseTrackingProvider()].forEach {
//            TrackingRepo.shared.register(trackingProvider: $0)
//        }

        // Register routing here
        let router: AppRouting = AppRouter.shared
        // swiftlint:disable no_hardcoded_strings
        router.register(path: "InternalMenu", navigator: InternalMenuNavigator())
        router.register(path: "DesignKit", navigator: DesignKitDemoNavigator())
        // swiftlint:enable no_hardcoded_strings

        let togglesDataStore: TogglesDataStoreType = BuildTargetTogglesDataStore.shared
        if togglesDataStore.isToggleOn(BuildTargetToggle.debug) {
            // There is still a bug in the Firebase Console, so the ID won't work until they fix it
            // https://github.com/firebase/firebase-ios-sdk/issues/6892#issuecomment-721795650
            /*
            Installations.installations().authTokenForcingRefresh(true) { token, error in
                // swiftlint:disable no_hardcoded_strings
                if let error = error {
                    print("Error fetching token: \(error)")
                    return
                }
                guard let token = token else { return }
                Installations.installations().installationID { id, _ in
                    print("Auth token: \(token.authToken)\nExpiration date: \(token.expirationDate)\nInstallation id: \(id ?? "invalid")")
                }
                // swiftlint:enable no_hardcoded_strings
            }
            */
        }
    }
}

//隐藏菜单激活
extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let togglesDataStore: TogglesDataStoreType = BuildTargetTogglesDataStore.shared
        if togglesDataStore.isToggleOn(BuildTargetToggle.debug)
            || togglesDataStore.isToggleOn(BuildTargetToggle.internal) {
            let router: AppRouting = AppRouter.shared
            if motion == .motionShake {
                //埋点
                //let trackingRepo: TrackingRepoType = TrackingRepo.shared
                // swiftlint:disable no_hardcoded_strings
                //记录埋点
                //trackingRepo.trackEvent(TrackingEvent(name: "shake", parameters: ["userID": UserDataStore.current.userID, "datetime": Date()]))
                router.route(to: URL(string: "\(UniversalLinks.baseURL)InternalMenu"), from: rootViewController, using: .present)
                // swiftlint:enable no_hardcoded_strings
            }
        }
    }
}
