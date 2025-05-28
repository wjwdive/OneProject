//
//  RemoteConfigProvider.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation

protocol RemoteConfigKey { }

protocol RemoteConfigProvider {
    func setup()
    func fetch()

    func getString(by key: RemoteConfigKey) -> String?
    func getInt(by key: RemoteConfigKey) -> Int?
    func getBool(by key: RemoteConfigKey) -> Bool
}
