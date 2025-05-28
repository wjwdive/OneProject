//
//  BaseListItemView.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation

import UIKit
import RxSwift

class BaseListItemView: UIView, ListItemView {
    lazy var disposeBag: DisposeBag = .init()
    
    //implemented by subclass
    //swiftlint:disable unavailable_function
    func update(with viewModel: ListItemViewModel) {
        fatalError(L10n.Development.fatalErrorSubclassToImplement)
    }
    //swiftlint:enable unavailable_function
}
