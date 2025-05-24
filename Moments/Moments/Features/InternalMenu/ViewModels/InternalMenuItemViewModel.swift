//
//  InternalMenuItemViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import Foundation

enum InternalMenuItemType: String {
    case description
    case featureToggle
    case actionTrigger
}

protocol InternalMenuItemViewModel {
    var type: InternalMenuItemType{ get }
    var title: String{ get }
    
    func select()
}

extension InternalMenuItemViewModel {
    func select() {}
}

