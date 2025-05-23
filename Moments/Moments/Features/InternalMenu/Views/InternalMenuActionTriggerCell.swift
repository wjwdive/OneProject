//
//  InternalMenuActionTriggerCell.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import UIKit

class InternalMenuActionTriggerCell: UITableViewCell, InternalMenuCellType {
    func update(with item: InternalMenuItemViewModel) {
        guard let item = item as? InternalMenuActionTriggerItemViewModel else {
            return
        }

        accessoryType = .disclosureIndicator
        textLabel?.text = item.title
    }
}
