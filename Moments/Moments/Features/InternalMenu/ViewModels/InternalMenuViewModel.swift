//
//  InternalMenuViewModel.swift
//  Moments
//
//  Created by wjw on 2025/5/23.
//

import RxSwift
import RxDataSources

protocol InternalMenuViewModelType {
    var title: String { get }
    var sections: Observable<[InternalMenuSection]> { get }
}

struct InternalMenuViewModel: InternalMenuViewModelType {
    let title = L10n.InternalMenu.area51
    let sections: Observable<[InternalMenuSection]>

    init(router: AppRouting, routingSourceProvider: @escaping RoutingSourceProvider) {
        //获取版本信息
        let appVersion = "\(L10n.InternalMenu.version) \((Bundle.main.object(forInfoDictionaryKey: L10n.InternalMenu.cfBundleVersion) as? String) ?? "1.0")"
        //第一个section 信息：只显示版本号 viewModel
        let infoSection = InternalMenuSection(
            title: L10n.InternalMenu.generalInfo,
            items: [InternalMenuDescriptionItemViewModel(title: appVersion)]
        )
        //第二个section designKitDemo 的跳转相关ViewModel
        let designKitSection = InternalMenuSection(
            title: L10n.InternalMenu.designKitDemo,
            items: [InternalMenuDesignKitDemoItemViewModel(router: router, routingSourceProvider: routingSourceProvider)])
        //第三个section featureToggles开关相关viewmodel
        let featureTogglesSection = InternalMenuSection(
            title: L10n.InternalMenu.featureToggles,
            items: [
                InternalMenuFeatureToggleItemViewModel(title: L10n.InternalMenu.likeButtonForMomentEnabled, toggle: InternalToggle.isLikeButtonForMomentEnabled)
            ])
        //第四个section 工具相关viewmodel
        let toolsSection = InternalMenuSection(
            title: L10n.InternalMenu.tools,
            items: [InternalMenuCrashAppItemViewModel()]
        )
        //使用 Rx的.just操作 将四个section组合成一个Observable的数组
        sections = .just([
            infoSection,
            designKitSection,
            featureTogglesSection,
            toolsSection
        ])
    }
}
