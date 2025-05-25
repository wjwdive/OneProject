//
//  InternalMenuNavigator.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import Foundation
import UIKit

struct InternalMenuNavigator: Navigating {
    func navigate(from viewController: UIViewController, using transitionType: TransitionType, parameters: [String : String]) {
        let togglesDataStore: TogglesDataStoreType = BuildTargetTogglesDataStore.shared
        guard togglesDataStore.isToggleOn(BuildTargetToggle.debug) || togglesDataStore.isToggleOn(BuildTargetToggle.internal) else {
            return
        }

        let navigationController = UINavigationController(rootViewController: InternalMenuViewController())
        print("InternalMenuNavigator navigate")
        navigate(to: navigationController, from: viewController, using: transitionType)
    }
}
