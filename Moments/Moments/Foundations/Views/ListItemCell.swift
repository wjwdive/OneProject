//
//  ListItemCell.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation

protocol ListItemCell: AnyObject {
    func update(with viewModel: ListItemViewModel)
}
