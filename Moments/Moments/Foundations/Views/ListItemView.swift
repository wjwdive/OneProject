//
//  ListItemView.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation

protocol ListItemView: AnyObject {
    func update(with viewModel: ListItemViewModel)
}
