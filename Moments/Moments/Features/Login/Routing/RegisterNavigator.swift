//
//  RegisterNavigator.swift
//  Moments
//
//  Created by wjw on 2025/6/23.
//

import Foundation
import UIKit

struct RegisterNavigator: Navigating {
    func navigate(from viewController: UIViewController, using transitionType: TransitionType, parameters: [String : String]) {

        let navigationController = UINavigationController(rootViewController: RegisterViewController())
        print("RegisterNavigator navigate")
        navigate(to: navigationController, from: viewController, using: transitionType)
    }
}
