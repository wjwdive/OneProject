//
//  FirebaseRemoteConfigProvider.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation

import FirebaseRemoteConfig

enum FirebaseRemoteConfigKey: String, RemoteConfigKey {
    case isRoundedAvatar
    case likeButtonStyle
}

struct FirebaseRemoteConfigProvider: RemoteConfigProvider {
    static let shared: FirebaseRemoteConfigProvider = .init()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    private init() { }
    
    func setup() {
        // swiftlint:disable no_hardcoded_strings
        remoteConfig.setDefaults(fromPlist: "FirebaseRemoteConfigDefaults")
        // swiftlint:enable no_hardcoded_strings
    }
    
    func fetch() {
        remoteConfig.fetchAndActivate()
    }
    
    func getString(by key: RemoteConfigKey) -> String? {
        guard let key = key as? FirebaseRemoteConfigKey else {
            return nil
        }
        
        return remoteConfig[key.rawValue].stringValue
    }
    
    func getInt(by key: RemoteConfigKey) -> Int? {
           guard let key = key as? FirebaseRemoteConfigKey else {
               return nil
           }

           return Int(truncating: remoteConfig[key.rawValue].numberValue)
       }

       func getBool(by key: RemoteConfigKey) -> Bool {
           guard let key = key as? FirebaseRemoteConfigKey else {
               return false
           }

           return remoteConfig[key.rawValue].boolValue
       }
}


