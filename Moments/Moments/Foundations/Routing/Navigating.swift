//
//  Navigating.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import Foundation
import UIKit

protocol Navigating {
    func navigate(from viewController: UIViewController, using transitionType: TransitionType, parameters: [String: String])
}

extension Navigating {
    func navigate(to destinationViewController: UIViewController, from sourceViewController: UIViewController, using transitionType: TransitionType) {
        switch transitionType {
        case .show:
            sourceViewController.show(destinationViewController, sender: nil)
        case .present:
            sourceViewController.present(destinationViewController, animated: true)
        }
    }
}
