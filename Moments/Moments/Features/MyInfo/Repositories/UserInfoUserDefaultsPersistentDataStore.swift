//
//  UserInfoUserDefaultsPersistentDataStore.swift
//  Moments
//
//  Created by wjw on 2025/6/5.
//

import Foundation
import RxSwift

struct UserInfoUserDefaultsPersistentDataStore: UserInfoPersistentDataStoreType {
    //在 Swift 中，静态属性（static let）的初始化是由编译器保证线程安全的。这是swift中单例的标准写法
    static let shared: UserInfoUserDefaultsPersistentDataStore = .init()
    
    //private(set)这个修饰符表示：momentsDetails 这个属性在当前类（或结构体）外部只能读取，不能修改，但在当前类型的实现内部可以修改。
    //换句话说，外部只能 get，内部可以 get/set。
    //= .create(bufferSize: 1) 通过 RxSwift 提供的 ReplaySubject 的工厂方法 .create(bufferSize: 1) 创建实例。
    private(set) var userInfo: ReplaySubject<UserInfoModel> = .create(bufferSize: 1)
    private let disposeBag: DisposeBag = .init()
    private let defaults = UserDefaults.standard
    private let userInfoKey = String(describing: UserInfoModel.self)
    
    private init() {
        setupBindings()
    }
    
    func save(userInfo: UserInfoModel) {
        if let encodeData = try? JSONEncoder().encode(userInfo) {
            defaults.set(encodeData, forKey: userInfoKey)
        }
    }
}

private extension UserInfoUserDefaultsPersistentDataStore {
    func setupBindings() {
        defaults.rx
            //监听 defaults中 userInfoKey对应的值Data的变化，key发生变化时会发出新的Data
            .observe(Data.self, userInfoKey)
            .compactMap{ $0 }   // 过滤掉 nil,只保留有值的Data
            //将上一步得到的 Data 用 JSONDecoder 解码成 UserInfoModel 类型的对象。 如果解码失败，则跳过（不会进入下一步）
            .compactMap{ try? JSONDecoder().decode(UserInfoModel.self, from: $0)}
            //将最终解码出来的 UserInfoModel 对象推送给 UserInfoModel 这个订阅者
            .subscribe(userInfo)
            //用 dispose bag 来管理订阅的生命周期，防止内存泄漏。
            .disposed(by: disposeBag)
    }
}
