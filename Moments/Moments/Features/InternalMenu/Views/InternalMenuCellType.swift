//
//  InternalMenuCellType.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import UIKit

    /// 菜单协议，默认三种菜单都遵循此协议
protocol InternalMenuCellType {
    func update(with item: InternalMenuItemViewModel)
}
