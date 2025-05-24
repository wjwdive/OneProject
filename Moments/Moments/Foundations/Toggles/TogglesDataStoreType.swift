//
//  TogglesDataStoreType.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import Foundation

protocol ToggleType { }

protocol TogglesDataStoreType {
    func isToggleOn(_ toggle: ToggleType) -> Bool
    func update(toggle: ToggleType, value: Bool)
}
