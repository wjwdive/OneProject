//
//  MomentsTimelineViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation

import RxSwift
import RxDataSources
/// 遵循了ListViewModel协议，因此需要实现了该协议中listItems和hasError属性以及loadItems()和trackScreenviews()方法。
struct MomentsTimelineViewModel: ListViewModel {
    private(set) var listItems: BehaviorSubject<[SectionModel<String, ListItemViewModel>]> = .init(value: [])
    private(set) var hasError: BehaviorSubject<Bool> = .init(value: false)
    
    private let disposeBag: DisposeBag = .init()
    private let userID: String
    private let momentsRepo: MomentsRepoType
//    private let trackingRepo: TrackingRepoType
    
    init(userID: String,
         momentsRepo: MomentsRepoType = MomentsRepo.shared
//         ,trackingRepo: TrackingRepoType = TrackingRepo.shared
    ){
        self.userID = userID
        self.momentsRepo = momentsRepo
//        self.trackingRepo = trackingRepo
        
        setupBindings()
    }
    
    /// ViewModel 需要读取数据的时候，会调用 Repository 模块的组件，在朋友圈功能中，我们调用了MomentsRepoType的getMoments()方法来读取数据。
    func loadItems() -> Observable<Void> {
        return momentsRepo.getMoments(userID: userID)
    }
    
    func trackScreenviews() {
//        trackingRepo.trackScreenViews(ScreenviewsTrackingEvent(screenName: L10.Tracking.momentsScreen),screenClass: String(describing: self)))
    }
}

private extension MomentsTimelineViewModel {
    /// 核心功能，是把 Model 数据转换为用于 UI 呈现所需的 ViewModel 数据
    func setupBindings() {
        /// 订阅了momentsRepo的momentsDetails属性，接收来自 Model 的数据更新；因为该属性的类型是MomentsDetails，而 View 层用所需的数据类型为ListItemViewModel。我们通过 map 操作符来进行类型转换，在转换成功后，调用listItems的onNext()方法把准备好的 ViewModel 数据发送给 UI。如果发生错误，就通过hasError属性发送出错信息。
        momentsRepo.momentsDetails
            /// map 操作符的转换过程中，我们分别使用了UserProfileListItemViewModel和MomentListItemViewModel结构体来转换用户简介信息和朋友圈条目信息。
            /// 将每一组数据转换为：先有一个“用户信息”ViewModel，后面紧跟该用户的朋友圈动态的ViewModel。
            /// 通常用于列表页面的section，section的顶部是用户信息，下面是内容（比如朋友圈）。
            ///最终得到的数组就是：
            ///  --用户信息的ViewModel
            ///     --动态1的ViewModel
            ///     --动态2的ViewMode·

            .map {
                [UserProfileListItemViewModel(userDetails: $0.moments.userDetail)]
                + $0.moments.moments.map { MomentListItemViewModel(moment: $0) }
            }
            .subscribe(onNext: {
                listItems.onNext([SectionModel(model: "", items: $0)])
            }, onError: {_ in
                hasError.onNext(true)
            })
            .disposed(by: disposeBag)
    }
}

