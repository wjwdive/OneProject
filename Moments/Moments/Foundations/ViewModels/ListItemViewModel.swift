//
//  ListItemViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation
import UIKit

/// ListItemViewModel用于定义每一条列表项所需的 ViewModel;   和ListViewModel配合，完成TableView的viewModel, 当他们需要读写数据时，会调用 Repository 模块。比如在朋友圈功能里面，它们都调用MoomentsRepoType来读写数据。
protocol ListItemViewModel {
    static var reuseIdentifier: String { get }
}

///reuseIdentifier属性作为 TableView Cell 的唯一标示，为了重用，我们通过协议扩展来为该属性提供一个默认的实现并把类型的名字作为字符串进行返回。
extension ListItemViewModel {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
