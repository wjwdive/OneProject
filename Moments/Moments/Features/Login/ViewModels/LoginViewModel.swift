import Foundation
import RxSwift
import RxCocoa
import Moya

protocol LoginViewModelProtocol {
    var userInfo: BehaviorSubject<UserInfoModel> { get }
    var hasError: BehaviorSubject<Bool> { get }
    
    func loginReq() -> Observable<Void>
    func registerReq() -> Observable<Void>
}

class AuthViewModel {
    // 输入
    let username = BehaviorRelay<String>(value: "")
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let loginTap = PublishSubject<Void>()
    let registerTap = PublishSubject<Void>()
    
    // 输出
    let isLoading = BehaviorRelay<Bool>(value: false)
    let authResult = PublishSubject<Result<User, AuthError>>()
    let errorMessage = PublishSubject<String>()
    
    private let authService = AuthService()
    private let disposeBag = DisposeBag()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // 登录绑定
        loginTap
            .withLatestFrom(Observable.combineLatest(email, password))
            .flatMapLatest { [weak self] (email, password) -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.performLoginRequest {
                    self.authService.login(username: email, password: password)
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        // 注册绑定
        registerTap
            .withLatestFrom(Observable.combineLatest(username, email, password))
            .flatMapLatest { [weak self] (username, email, password) -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.performRegisterRequest {
                    self.authService.register(username: username, email: email, password: password)
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func performLoginRequest(_ request: @escaping () -> Single<LoginData>) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            self.isLoading.accept(true)
            
            let disposable = request()
                .subscribe { [weak self] event in
                    self?.isLoading.accept(false)
                    switch event {
                    case .success(let loginData):
                        // 将 LoginData 转换为 User
                        let user = User(
                            userId: loginData.userId,
                            username: loginData.username,
                            email: nil, // 登录响应可能没有email
                            avatarUrl: loginData.avatarUrl,
                            token: loginData.token
                        )
                        self?.authResult.onNext(.success(user))
                    case .error(let error as AuthError):
                        self?.errorMessage.onNext(error.description)
                    case .error(_):
                        self?.errorMessage.onNext(AuthError.serverError.description)
                    }
                    observer.onCompleted()
                }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    private func performRegisterRequest(_ request: @escaping () -> Single<RegisterData>) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            self.isLoading.accept(true)
            
            let disposable = request()
                .subscribe { [weak self] event in
                    self?.isLoading.accept(false)
                    switch event {
                    case .success(let registerData):
                        // 将 RegisterData 转换为 User
                        let user = User(
                            userId: registerData.userId,
                            username: registerData.username,
                            email: registerData.email,
                            avatarUrl: nil, // 注册响应可能没有avatarUrl
                            token: nil // 注册响应可能没有token
                        )
                        self?.authResult.onNext(.success(user))
                    case .error(let error as AuthError):
                        self?.errorMessage.onNext(error.description)
                    case .error(_):
                        self?.errorMessage.onNext(AuthError.serverError.description)
                    }
                    observer.onCompleted()
                }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
} 
