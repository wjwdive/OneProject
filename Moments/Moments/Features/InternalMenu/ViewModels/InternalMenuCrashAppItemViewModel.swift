//
//  InternalMenuCrashAppItemViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import Foundation

final class InternalMenuCrashAppItemViewModel: InternalMenuActionTriggerItemViewModel {
    override var title: String {
        return L10n.InternalMenu.crashApp
    }

    // swiftlint:disable unavailable_function
    override func select() {
        // swiftlint:disable fatal_error_message
        fatalError()
    }
}
