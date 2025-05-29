//
//  ListViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation
import RxSwift
import RxDataSources
/// ListViewModel协议用于定义列表页面所需的 ViewModel,和ListItemViewModel配合，完成TableView的viewModel,见 ListItemViewModel
protocol ListViewModel {
    //只读属性，
    ///该属性用于准备 TableView 所需的数据，其存放了类型为ListItemViewModel的数据。ListItemViewModel能为 TableView 的各个 Cell 提供所需数据。该协议只定义一个名为reuseIdentifier的静态属性 ，如下所示。
    var listItems: BehaviorSubject<[SectionModel<String, ListItemViewModel>]> { get }
    //hasContent属性用于通知 UI 是否有内容;网络返回无数据时，可以在页面上提示用户“目前还没有朋友圈信息，可以添加好友来查看更多的朋友圈信息”
    var hasContent: Observable<Bool> { get }
    //hasError属性是一个BehaviorSubject，其初始值为false。它用于通知 UI 是否需要显示错误信息。
    var hasError: BehaviorSubject<Bool> { get }
    
    //trackScreenviews()方法用于发送用户行为数据。
    func trackScreenviews()
    
    //Need the conformed class to implement
    //loadItems() -> Observable<Void>方法用于读取数据
    func loadItems() -> Observable<Void>
}

extension ListViewModel {
    // hasContent的默认实现
    var hasContent: Observable<Bool> {
        return listItems
            ///使用map和distinctUntilChanged操作符来把listItems转换成 Bool 类型的hasContent
            ///map用于提取listItems里的数组并检查是否为空，
            ///distinctUntilChanged用来保证只有在值发生改变时才发送新事件。
            .map(\.isEmpty)//\.isEmpty 是一个 key path，代表“取 isEmpty 属性”。 等价于 .map { $0.isEmpty }。其中map用于提取listItems里的数组并检查是否为空
            .distinctUntilChanged()//distinctUntilChanged用来保证只有在值发生改变时才发送新事件。
            .asObservable()
    }
}
