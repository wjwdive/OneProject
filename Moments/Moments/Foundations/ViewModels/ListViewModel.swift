//
//  ListViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation
import RxSwift
import RxDataSources

protocol ListViewModel {
    //只读属性，
    var listItems: BehaviorSubject<[SectionModel<String, ListItemViewModel>]> { get }
    var hasContent: Observable<Bool> { get }
    var hasError: BehaviorSubject<Bool> { get }
    
    func trackScreenviews()
    
    //Need the conformed class to implement
    func loadItems() -> Observable<Void>
}

extension ListViewModel {
    var hasContent: Observable<Bool> {
        return listItems
            .map(\.isEmpty)//\.isEmpty 是一个 key path，代表“取 isEmpty 属性”。 等价于 .map { $0.isEmpty }。其中map用于提取listItems里的数组并检查是否为空
            .distinctUntilChanged()//distinctUntilChanged用来保证只有在值发生改变时才发送新事件。
            .asObservable()
    }
}
