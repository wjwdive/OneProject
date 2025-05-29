//
//  MomentsRepo.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation
import RxSwift
import UIKit

protocol MomentsRepoType {
    var momentsDetails: ReplaySubject<MomentsDetails> { get }
    func getMoments(userID: String) -> Observable<Void>
    func updateLike(isLiked: Bool, momentID: String, fromUserID userID: String) -> Observable<Void>
}

struct MomentsRepo: MomentsRepoType {
    private(set) var momentsDetails: ReplaySubject<MomentsDetails> = .create(bufferSize: 1)
    private let disposeBag: DisposeBag = .init()
    
    private let persistentDataStore: PersistentDataStoreType
    private let getMomentsByUserIDRestful: GetMomentsByUserIDSessionType
    private let updateMomentLikeSession: UpdateMomentLikeSessionType
    
    static  let shared: MomentsRepo = {
        return MomentsRepo(
            persistentDataStore: UserDefaultsPersistentDataStore.shared,
            getMomentsByUserIDSession: GetMomentsByUserIDRestful(),
            updateMomentLikeSession: UpdateMomentLikeSession()
        )
    }()
    
    init(persistentDataStore: PersistentDataStoreType,
         getMomentsByUserIDSession: GetMomentsByUserIDSessionType,
         updateMomentLikeSession: UpdateMomentLikeSessionType) {
        self.persistentDataStore = persistentDataStore
        self.getMomentsByUserIDRestful = getMomentsByUserIDSession
        self.updateMomentLikeSession = updateMomentLikeSession
        
        setupBindings()
    }
    
    func getMoments(userID: String) -> Observable<Void> {
        return getMomentsByUserIDRestful
            .getMoments(userID: userID)
            .do(onNext: {persistentDataStore.save(momentsDetails: $0)})
                .map {_ in() }
                .catchErrorJustReturn(())
    }
    
    func updateLike(isLiked: Bool, momentID: String, fromUserID userID: String) -> Observable<Void> {
        return updateMomentLikeSession
            .updateLike(isLiked, momentID: momentID, fromUserID: userID)
            .do(onNext: {persistentDataStore.save(momentsDetails:  $0 )})
                .map{_ in () }
                .catchErrorJustReturn(())
    }
}

private extension MomentsRepo {
    func setupBindings() {
        persistentDataStore.momentsDetails
            .subscribe(momentsDetails)
            .disposed(by: disposeBag)
    }
}
