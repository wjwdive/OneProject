//
//  RootNavNavigator.swift
//  Moments
//
//  Created by wjw on 2025/6/24.
//

import Foundation
import UIKit

struct RootNavNavigator: Navigating {
    func navigate(from viewController: UIViewController, using transitionType: TransitionType, parameters: [String : String]) {

        let navigationController = UINavigationController(rootViewController: RootNavigationController())
        print("RootNavigationController navigate")
        navigate(to: navigationController, from:viewController , using: transitionType)
    }
}
