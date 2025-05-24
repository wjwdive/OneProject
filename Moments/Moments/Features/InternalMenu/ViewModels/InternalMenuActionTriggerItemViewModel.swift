//
//  InternalMenuActionTriggerItemViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import Foundation
import UIKit
//import DesignKit

class InternalMenuActionTriggerItemViewModel: InternalMenuItemViewModel {
    let type: InternalMenuItemType  = .actionTrigger

    var title: String { fatalError(L10n.Development.fatalErrorSubclassToImplement) }

    // swiftlint:disable unavailable_function
    func select() { fatalError(L10n.Development.fatalErrorSubclassToImplement) }
}
