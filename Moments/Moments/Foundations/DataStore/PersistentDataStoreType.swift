//
//  PersistentDataStoreType.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation
import RxSwift

protocol PersistentDataStoreType {
    var momentsDetails: ReplaySubject<MomentsDetails> { get }
    func save(momentsDetails: MomentsDetails)
}
