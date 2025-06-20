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
    let passwordConfirm = BehaviorRelay<String>(value: "")
    let confirmPassword = BehaviorRelay<String>(value: "")
    

    let loginTap = PublishSubject<Void>()
    let registerTap = PublishSubject<Void>()
    
    // 输出
    let isLoading = BehaviorRelay<Bool>(value: false)
    let authResult = PublishSubject<Result<User, AuthError>>()
    let errorMessage = PublishSubject<String>()
    //username,email avaiable
    let availabelResult = PublishSubject<Result<IsAvailableData, AuthError>>()
    
    //用户名和邮箱限制 都是最少5位，最长25位
    let minUsernameLength = 5
    let minPasswordLength = 4
    let maxUsernameLength = 25
    let maxPasswordLength = 25
    
    var isUsernameValid: Observable<Bool>
    var isEmailValid: Observable<Bool>
    var isPasswordValid: Observable<Bool>
    //长度格式校验
    var isUsernameLengthValid : Observable<Bool>
    var isEmailFormatValid : Observable<Bool>
    var isConfirmPasswordValid: Observable<Bool>
    var shouldShowConfirmPasswordError: Observable<Bool>
    
    //是否是登录模式，默认是
    let isLoginMode = BehaviorRelay<Bool>(value: true)
    
    private let authService = AuthService()
    private let disposeBag = DisposeBag()
    
    init() {
        // 先初始化
        isUsernameValid = Observable.just(false)
        isEmailValid = Observable.just(false)
        isPasswordValid = Observable.just(false)
        isUsernameLengthValid = Observable.just(false)
        isEmailFormatValid = Observable.just(false)
        isConfirmPasswordValid = Observable.just(false)
        shouldShowConfirmPasswordError = Observable.just(false)
        checkValid()
        setupBindings()
        isLoginMode.accept(true)
    }
    private func checkValid() {
        isUsernameLengthValid = username.map { $0.count >= self.minUsernameLength && $0.count <= self.maxUsernameLength && self.isValidUsername($0) }
        isEmailFormatValid = email.map { $0.count >= self.minUsernameLength && $0.count <= self.maxUsernameLength && self.isValidEmail($0) }
        isPasswordValid = password.map { $0.count >= 4 }
        
        // 用户名可用性校验（防抖+接口）
        isUsernameValid = username
                .distinctUntilChanged()
                .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
                .withLatestFrom(isUsernameLengthValid) { ($0, $1) }
                .flatMapLatest { [weak self] (name, isValid) -> Observable<Bool> in
                    guard let self = self, isValid else { return .just(false)}
                    return self.authService.isUsernameAvailable(username: name)
                     .asObservable()
                     .map { $0.available }
                     .catchErrorJustReturn(false)
                     //.catchAndReturn(false)//RxSwift 6.0 才支持//网络异常时返回false
                }
        
        isEmailValid = email
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] email -> Observable<Bool> in
                guard let self = self, self.isValidEmail(email) else {return .just(false)}
                return self.authService.isEmailAvailable(email: email)
                .asObservable()
                .map { $0.available }
                .catchErrorJustReturn(false)
                //.catchAndReturn(false)//网络异常时返回false
            }

        isConfirmPasswordValid = Observable
            .combineLatest(password, confirmPassword) { $0 == $1 && !$1.isEmpty }
    }

    // 校验用户名格式的正则表达式函数
    func isValidUsername(_ username: String) -> Bool {
        let pattern = "^[A-Za-z0-9]+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: username.utf16.count)
        return regex?.firstMatch(in: username, options: [], range: range) != nil
    }
    // 校验邮箱格式的正则表达式函数
    func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex?.firstMatch(in: email, options: [], range: range) != nil
    }
    
    private func setupBindings() {
        // 登录绑定
        loginTap
            .withLatestFrom(Observable.combineLatest(username, password))
            .flatMapLatest { [weak self] (username, password) -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.performLoginRequest {
                    self.authService.login(username: username, password: password)
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

    private func performUsernameCheckRequest(_ request: @escaping () -> Single<IsAvailableData>) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.isLoading.accept(true)
            let disposable = request()
                .subscribe { [weak self] event in
                    self?.isLoading.accept(false)
                    switch event {
                    case .success(let IsValidData):
                        let isAvailableData = IsAvailableData(
                            available: IsValidData.available
                        )
                        self?.availabelResult.onNext(.success(isAvailableData))
                    case .error(let error as AuthError):
                        self?.errorMessage.onNext(error.description)
                    case .error(_):
                        self?.errorMessage.onNext(AuthError.serverError.description)
                    }
                    observer.onCompleted()
                }
            return Disposables.create{
                disposable.dispose()
            }
        }
    }
    
    
    private func performEmailCheckRequest(_ request: @escaping () -> Single<IsAvailableData>) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.isLoading.accept(true)
            let disposable = request()
                .subscribe { [weak self] event in
                    self?.isLoading.accept(false)
                    switch event {
                    case .success(let IsValidData):
                        let isAvailableData = IsAvailableData(
                            available: IsValidData.available
                        )
                        self?.availabelResult.onNext(.success(isAvailableData))
                    case .error(let error as AuthError):
                        self?.errorMessage.onNext(error.description)
                    case .error(_):
                        self?.errorMessage.onNext(AuthError.serverError.description)
                    }
                    observer.onCompleted()
                }
            return Disposables.create{
                disposable.dispose()
            }
        }
    }
    
}

