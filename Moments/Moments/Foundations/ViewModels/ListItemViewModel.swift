//
//  ListItemViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation
import UIKit


protocol ListItemViewModel {
    static var reuseIdentifier: String { get }
}

extension ListItemViewModel {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
