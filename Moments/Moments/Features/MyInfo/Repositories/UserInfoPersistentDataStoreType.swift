//
//  UserInfoPersistentDataStoreType.swift
//  Moments
//
//  Created by wjw on 2025/6/5.
//

import Foundation
import RxSwift

protocol UserInfoPersistentDataStoreType{
    var userInfo: ReplaySubject<UserInfoModel> { get }
    func save(userInfo: UserInfoModel)
}

