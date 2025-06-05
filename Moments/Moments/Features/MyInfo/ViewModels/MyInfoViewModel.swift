import Foundation
import RxSwift
import RxCocoa

protocol UserInfoViewModel {
    var userInfo: BehaviorSubject<UserInfoModel> { get }
    //hasContent属性用于通知 UI 是否有内容;网络返回无数据时，可以在页面上提示用户"目前还没有朋友圈信息，可以添加好友来查看更多的朋友圈信息"
    var hasContent: Observable<Bool> { get }
    //hasError属性是一个BehaviorSubject，其初始值为false。它用于通知 UI 是否需要显示错误信息。
    var hasError: BehaviorSubject<Bool> { get }
    
    //trackScreenviews()方法用于发送用户行为数据。
    func trackScreenviews()
    
    //Need the conformed class to implement
    //loadItems() -> Observable<Void>方法用于读取数据
    func loadUserInfoData() -> Observable<Void>
    
    func retry()
}

class MyInfoViewModel: UserInfoViewModel {
    private let disposeBag = DisposeBag()
    private let userInfoRepo: UserInfoRepo
    private let userId: String
    
    // 用户信息
    private(set) var userInfo: BehaviorSubject<UserInfoModel> = .init(value: UserInfoModel(
        userId: 0,
        username: "",
        avatarUrl: nil as String?,
        createdAt: nil as Date?,
        updatedAt: nil as Date?,
        deletedAt: nil as Date?,
        isDeleted: 0
    ))
    
    // 加载状态
    private(set) var isLoading = BehaviorSubject<Bool>(value: false)
    
    // 错误信息
    private(set) var error = BehaviorSubject<String?>(value: nil)
    
    // 是否有内容
    var hasContent: Observable<Bool> {
        return userInfo
            .map { !$0.username.isEmpty }
    }
    
    init(userId: String, userInfoRepo: UserInfoRepo = UserInfoRepo.shared) {
        self.userId = userId
        self.userInfoRepo = userInfoRepo
        
        // 在初始化时开始数据流
        setupDataFlow()
    }
    
    private func setupDataFlow() {
        print("MyInfoViewModel: Setting up data flow")
        
        // 订阅 Repository 的数据流
        userInfoRepo.userInfo
            .subscribe(onNext: { [weak self] userInfo in
                print("MyInfoViewModel: Received user info from repo: \(userInfo)")
                self?.userInfo.onNext(userInfo)
            })
            .disposed(by: disposeBag)
        
        // 开始加载数据
        print("MyInfoViewModel: Starting to load user info for userId: \(userId)")
        userInfoRepo.getUserInfo(userID: userId)
            .subscribe(onNext: { [weak self] _ in
                print("MyInfoViewModel: Successfully loaded user info")
                self?.isLoading.onNext(false)
            }, onError: { [weak self] error in
                print("MyInfoViewModel: Error loading user info: \(error)")
                self?.error.onNext(error.localizedDescription)
                self?.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func loadUserInfoData() -> Observable<Void> {
        print("MyInfoViewModel: loadUserInfoData called")
        isLoading.onNext(true)
        error.onNext(nil)
        
        return userInfoRepo.getUserInfo(userID: userId)
    }
    
    func retry() {
        print("MyInfoViewModel: Retrying to load user info")
        userInfoRepo.getUserInfo(userID: userId)
            .subscribe(onNext: { [weak self] _ in
                print("MyInfoViewModel: Successfully retried loading user info")
                self?.isLoading.onNext(false)
            }, onError: { [weak self] error in
                print("MyInfoViewModel: Error retrying to load user info: \(error)")
                self?.error.onNext(error.localizedDescription)
                self?.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func trackScreenviews() {
        // TODO: 实现屏幕浏览追踪
    }
}

extension MyInfoViewModel {
    // hasError的默认实现
    var hasError: BehaviorSubject<Bool> {
        let subject = BehaviorSubject<Bool>(value: false)
        error
            .map { $0 != nil }
            .subscribe(subject)
            .disposed(by: disposeBag)
        return subject
    }
}
