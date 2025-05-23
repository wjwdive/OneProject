//
//  InternalMenuFeatureToggleItemViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import Foundation

struct InternalMenuFeatureToggleItemViewModel: InternalMenuItemViewModel {
    private let toggle: ToggleType
    private let togglesDataStore: TogglesDataStoreType

    init(title: String, toggle: ToggleType, togglesDataStore: TogglesDataStoreType = InternalTogglesDataStore.shared) {
        self.title = title
        self.toggle = toggle
        self.togglesDataStore = togglesDataStore
    }

    let type: InternalMenuItemType = .featureToggle
    let title: String

    var isOn: Bool {
       return togglesDataStore.isToggleOn(toggle)
    }

    func toggle(isOn: Bool) {
        togglesDataStore.update(toggle: toggle, value: isOn)
    }
}
