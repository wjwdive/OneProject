//
//  MomentsRepo.swift
//  Moments
//
//  Created by wjw on 2025/6/04.
//

import Foundation
import RxSwift
import UIKit

protocol UserInfoRepoType {
    var userInfo: ReplaySubject<UserInfoModel> { get }
    func getUserInfo(userID: String) -> Observable<Void>
//    func updateLike(isLiked: Bool, momentID: String, fromUserID userID: String) -> Observable<Void>
}

struct UserInfoRepo: UserInfoRepoType {
    private(set) var userInfo: ReplaySubject<UserInfoModel> = .create(bufferSize: 1)
    private let disposeBag: DisposeBag = .init()
    
    private let userInfoPersistentDataStore: UserInfoPersistentDataStoreType
    private let getUserInfoByUserIDSession: GetUserInfoByUserIDSessionType
    
    static  let shared: UserInfoRepo = {
        return UserInfoRepo(
            userInfoPersistentDataStore: UserInfoUserDefaultsPersistentDataStore.shared,
            getUserInfoByUserIDSession: GetUserInfoByUserIdRestful()
        )
    }()
    
    init(userInfoPersistentDataStore: UserInfoPersistentDataStoreType,
         getUserInfoByUserIDSession: GetUserInfoByUserIDSessionType) {
        self.userInfoPersistentDataStore = userInfoPersistentDataStore
        self.getUserInfoByUserIDSession = getUserInfoByUserIDSession
        
        setupBindings()
    }
    
    func getUserInfo(userID: String) -> Observable<Void> {
        return getUserInfoByUserIDSession
            .getUserInfo(userID: userID)
            .do(onNext: { userInfo in
                self.userInfoPersistentDataStore.save(userInfo: userInfo)
            })
            .map { _ in () }
            .catchError { error in
                print("获取用户信息失败: \(error)")
                return .empty()
            }
    }
    
//    func updateLike(isLiked: Bool, momentID: String, fromUserID userID: String) -> Observable<Void> {
//        return updateMomentLikeSession
//            .updateLike(isLiked, momentID: momentID, fromUserID: userID)
//            .do(onNext: {persistentDataStore.save(momentsDetails:  $0 )})
//                .map{_ in () }
//                .catchErrorJustReturn(())
//    }
}

private extension UserInfoRepo {
    func setupBindings() {
        userInfoPersistentDataStore.userInfo
            .subscribe(userInfo)
            .disposed(by: disposeBag)
    }
}
