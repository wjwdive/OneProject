//
//  UserDataStore.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation

protocol UserDataStoreType {
    var userID: String { get }
}

struct UserDataStore: UserDataStoreType {
    var userID: String {
        "0"
    }
    
    private init() { }
    
    static  let current = UserDataStore()
}
