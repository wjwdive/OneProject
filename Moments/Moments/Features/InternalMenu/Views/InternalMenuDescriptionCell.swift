//
//  InternalMenuDescriptionCell.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import UIKit

//class InternalMenuDescriptionCell: UITableViewCell, InternalMenuCellType {
//    func update(with item: InternalMenuItemViewModel) {
//        guard let item = item as? InternalMenuDescriptionItemViewModel else {
//            return
//        }
//
//        selectionStyle = .none
//        textLabel?.text = item.title
//    }
//}
class InternalMenuDescriptionCell: UITableViewCell, InternalMenuCellType {
    func update(with item: InternalMenuItemViewModel) {
        guard let item = item as? InternalMenuDescriptionItemViewModel else {
            return
        }
        selectionStyle = .none
        textLabel?.text = item.title
    }
}
