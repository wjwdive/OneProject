//
//  LoginViewModel.swift
//  Moments
//
//  Created by wjw on 2025/6/20.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

enum AuthMode {
    case login
    case register
}

struct AuthState {
    var mode: AuthMode
    var isLoading: Bool
    var username: String
    var password: String
    var confirmPassword: String //注册专用
    var errorMessage: String?
    var token: String?
    
    
    //计算属性： 登录按钮是否可用
    var isLoginEnabled: Bool {
        !username.isEmpty && !password.isEmpty && !isLoading
    }
    
    //计算属性：注册按钮是否可用
    var isRegisterEnabled: Bool  {
        isLoginEnabled && !confirmPassword.isEmpty && password == confirmPassword
    }
}


//登录viewModel(继承基础类)
class LoginViewModel: BaseAuthViewModel, ViewModelType {
    enum LoginMethod{
        case password
        case phone
    }
    
    struct Input{
        let username: Observable<String>
        let password: Observable<String>
        let loginTap: Observable<Void>
        let registerTap: Observable<Void>
        let forgotPasswordTap: Observable<Void>
    }
    
    let method = BehaviorRelay(value: LoginMethod.password)
    let username = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    let phone = BehaviorRelay(value: "")
    let captcha = BehaviorRelay(value: "")
    
    struct Output {
        //表单状态
        let isLoginEnabled: Driver<Bool>
        
        //加载状态
        let isLoading: Driver<Bool>
        
        //导航指令
        let showRegister: Driver<Void>
        let showPhoneLogin: Driver<Void>
        //操作结果
        let loginResult: Driver<Result<LoginData, AppError>>
        //错误信息
        let errorMessage: Driver<String?>
        
        //输入校验错误提示
        let usernameError: Driver<String?>
        let passwordError: Driver<String?>
        
    }
    
    // MARK: - 内部状态
    private let methodRelay = BehaviorRelay<LoginMethod>(value: .password)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorRelay = PublishRelay<String?>()
    
    //Mark: -- 转换方法
    func transform(input: Input) -> Output {
        //处理表单有效性
        let isFormValid = Observable.combineLatest(
            input.username.map { !$0.isEmpty },
            input.password.map { !$0.isEmpty }
        ).map { $0 && $1 }
        
        // 用户名本地校验
        let usernameError = input.username
            .map { username -> String? in
                let regex = "^[A-Za-z0-9]{5,25}$"
                let pred = NSPredicate(format: "SELF MATCHES %@", regex)
                if pred.evaluate(with: username) {
                    return nil
                } else if username.isEmpty {
                    return nil
                } else {
                    return "用户名格式不正确"
                }
            }
            .asDriver(onErrorJustReturn: nil)

        // 密码本地校验
        let passwordError = input.password
            .map { password -> String? in
                let regex = "^[A-Za-z0-9@#$%^&+=]{4,25}$"
                let pred = NSPredicate(format: "SELF MATCHES %@", regex)
                if pred.evaluate(with: password) {
                    return nil
                } else if password.isEmpty {
                    return nil
                } else {
                    return "密码格式不正确"
                }
            }
            .asDriver(onErrorJustReturn: nil)

        //处理登录请求
        let loginRequest = input.loginTap
            .withLatestFrom(Observable.combineLatest(input.username, input.password))
            .flatMapLatest { [weak self] (username, password) -> Observable<Result<LoginData, AppError>> in
                guard let self = self else { return .empty() }
                // 开始加载
                self.isLoadingRelay.accept(true)
                
                return self.authService.login(username: username, password: password)
                    .asObservable()
                    .flatMap { baseResponse -> Observable<Result<LoginData, AppError>> in
                        // 1. 检查业务状态码
                        if baseResponse.statusCode == 2000, let loginData = baseResponse.data {
//                            let user = User(
//                                userId: loginData.userId,
//                                username: loginData.username,
//                                email: loginData.email,
//                                token: loginData.token,
//                                avatar: loginData.avatarURL
//                            )
                            return .just(.success(loginData))
                        } else {
                            // 2. 业务错误转换为AppError
                            let error = AppError.businessError(
                                code: baseResponse.statusCode,
                                message: baseResponse.message,
                                detail: "业务操作失败"
                                )
                            return .just(.failure(error))
                        }
                    }
                    .catchError { error -> Observable<Result<LoginData, AppError>> in
                        // 3. 确保所有错误都是AppError类型
                        if let appError = error as? AppError {
                            return .just(.failure(appError))
                        }
                        return .just(.failure(AppError.networkError.withDetail("\(error)")))
                    }
                    .do(
                        onNext: { [weak self] (_: Result<LoginData, AppError>) in
                            self?.isLoadingRelay.accept(false)
                        }, onError: { [weak self] (_: Error)  in
                            self?.isLoadingRelay.accept(false)
                        },onDispose: { [weak self] in
                            self?.isLoadingRelay.accept(false)
                        }
                    )
            }
            .share(replay: 1, scope: .whileConnected)
        
        //处理错误
        let errorMessage = loginRequest
            .map { result -> String? in
                if case .failure(let error) = result {
                    if let appError = error as? AppError {
                        print("⚠️ [错误详情] \(appError.errorDetail)")
                        return appError.message
                    } else {
                        print("⚠️ [错误详情] \(error.localizedDescription)")
                        return error.localizedDescription
                    }
                }
                return nil
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Output(
            isLoginEnabled: isFormValid.asDriver(onErrorJustReturn: false),
            isLoading: isLoadingRelay.asDriver(),
            showRegister: .empty(),
            showPhoneLogin: .empty(),
            loginResult: loginRequest.asDriver(onErrorDriveWith: .empty()),
            errorMessage: errorMessage,
            usernameError: usernameError,
            passwordError: passwordError
        )
    }
    
    // 自定义错误消息格式化
    private func prettyErrorMessage(for error: Error) -> String {
        if let authError = error as? AuthError {
            switch authError {
            case .invalidCredentials:
                return "用户名或密码错误"
            case .validationFailed(let errors):
                return errors.values.first?.first ?? "数据验证失败"
            case .emailAlreadyExists:
                return "邮箱已被注册"
            case .networkError:
                return "网络连接失败，请检查网络"
            default:
                return "认证错误: \(error.localizedDescription)"
            }
        }
        
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .statusCode(let response):
                return "服务器错误 (\(response.statusCode))"
            case .underlying(let underlyingError, _):
                return "网络错误: \(underlyingError.localizedDescription)"
            default:
                return "请求错误: \(error.localizedDescription)"
            }
        }
        return error.localizedDescription
    }
    
    // 当前登录方式是否有效
    var isFormValid: Observable<Bool> {
        return method.flatMapLatest { [weak self] method -> Observable<Bool> in
            guard let self = self else { return .just(false) }
            
            switch method {
            case .password:
                return Observable.combineLatest(
                    self.username.map { self.validateEmail($0) },
                    self.password.map { !$0.isEmpty }
                ).map { $0 && $1 }
                
            case .phone:
                return Observable.combineLatest(
                    self.phone.map { self.validatePhone($0) },
                    self.captcha.map { !$0.isEmpty }
                ).map { $0 && $1 }
            }
        }
    }
    
    //登录方法
    func login() {
        isLoading.accept(true)
        
        switch method.value {
        case .password:
            authService.login(
                username: username.value,
                password: password.value
            ).subscribe(
                onSuccess: { [weak self] response in
                    self?.isLoading.accept(false)
                    // 如果 event 是自定义类型，可以打印其属性
                    if let loginData = response as? LoginData {
                        // print("用户ID: \(loginResponse.userId)")
                        print("用户名: \(loginData.username)")
                        print("Token: \(loginData.token)")
                    }
                    print("=== 登录响应数据 ===")
                    print("类型: \(type(of: response))")
                    
                    // 使用反射打印所有属性
                    let mirror = Mirror(reflecting: response)
                    for child in mirror.children {
                        if let label = child.label {
                            print("\(label): \(child.value)")
                        }
                    }
                    print("==================")
            
                    self?.isLoading.accept(false)
//                    self?.handleLoginSuccess(response)
                },
                onError: { [weak self] in
                    self?.handleError($0)
                }
            ).disposed(by: disposeBag)
            
        case .phone:
            authService.loginWithPhone(
                phone: phone.value,
                captcha: captcha.value
            ).subscribe(
                onSuccess: { [weak self] event in
                    self?.isLoading.accept(false)
                    // 登录成功处理
                    //print(".phone event:\(event.description))
                },
                onError: { [weak self] in
                    self?.handleError($0)
                }
            ).disposed(by: disposeBag)
        }
    }
            
}
