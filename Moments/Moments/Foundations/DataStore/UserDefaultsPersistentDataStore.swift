//
//  UserDefaultsPersistentDataStore.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation
import RxSwift

struct UserDefaultsPersistentDataStore: PersistentDataStoreType {
    static let shared: UserDefaultsPersistentDataStore = .init()
    
    private(set) var momentsDetails: ReplaySubject<MomentsDetails> = .create(bufferSize: 1)
    private let disposeBag: DisposeBag = .init()
    private let defaults = UserDefaults.standard
    private let momentsDetailsKey = String(describing: MomentsDetails.self)
    
    private init() {
        setupBindings()
    }
    
    func save(momentsDetails: MomentsDetails) {
        if let encodeData = try? JSONEncoder().encode(momentsDetails) {
            defaults.set(encodeData, forKey: momentsDetailsKey)
        }
    }
}

private extension UserDefaultsPersistentDataStore {
    func setupBindings() {
        defaults.rx
            .observe(Data.self, momentsDetailsKey)
            .compactMap{ $0 }
            .compactMap{ try? JSONDecoder().decode(MomentsDetails.self, from: $0)}
            .subscribe(momentsDetails)
            .disposed(by: disposeBag)
    }
}
