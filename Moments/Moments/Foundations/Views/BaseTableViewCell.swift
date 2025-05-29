//
//  BaseTableViewCell.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation
import UIKit

final class BaseTableViewCell<V: BaseListItemView>: UITableViewCell, ListItemCell {
    private let view: V
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        view = .init()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    //重写init 方法，并抛出异常，防止外部误调用
    //swiftlint:disable unavailable_function
    required init?(coder: NSCoder) {
        fatalError(L10n.Development.fatalErrorInitCoderNotImplemented)
    }
    //swiftlint:enable unavailable_function
    
    func update(with viewModel: ListItemViewModel) {
        view.update(with: viewModel)
    }
    
}
