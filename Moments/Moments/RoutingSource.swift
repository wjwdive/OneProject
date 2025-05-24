//
//  RoutingSource.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import Foundation
import UIKit

protocol RoutingSource: AnyObject { }

typealias RoutingSourceProvider = () -> RoutingSource?

extension UIViewController: RoutingSource { }
