//
//  FirebaseRemoteTogglesDataStore.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation

enum RemoteToggle: String, ToggleType {
    case isRoundedAvatar
}

struct FirebaseRemoteToggleDataStore: TogglesDataStoreType {
    static let shared: FirebaseRemoteToggleDataStore = .init()
    
    private let remoteConfigProvider: RemoteConfigProvider
    
    private init(remoteConfigProvider: RemoteConfigProvider = FirebaseRemoteConfigProvider.shared) {
        self.remoteConfigProvider = remoteConfigProvider
        self.remoteConfigProvider.setup()
        self.remoteConfigProvider.fetch()
    }
    
    func isToggleOn(_ toggle: ToggleType) -> Bool {
        guard let toggle = toggle as? RemoteToggle, let remoteConfigKey = FirebaseRemoteConfigKey(rawValue: toggle.rawValue) else { return false }
        return remoteConfigProvider.getBool(by: remoteConfigKey)
    }
    
    func update(toggle: ToggleType, value: Bool) { }
}
