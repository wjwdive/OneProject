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
import simd


protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

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


class BaseAuthViewModel {
    //公共状态
    let isLoading = BehaviorRelay(value: false)
    let errorMessage = PublishRelay<String?>()
    
    let authService = AuthService()
    let disposeBag = DisposeBag()
    
    //公共方法
    func handleError(_ error: Error) {
        errorMessage.accept(error.localizedDescription)
        isLoading.accept(false)
    }
    
    // 公共验证逻辑
    func validateEmail(_ email: String) -> Bool {
        // 邮箱验证逻辑
        return true
    }
    
    func validatePhone(_ phone: String) -> Bool {
        // 手机号验证逻辑
        return true
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
        let loginResult: Driver<Result<User, Error>>
        //错误信息
        let errorMessage: Driver<String?>
    }
    
    // MARK: - 内部状态
    private let methodRelay = BehaviorRelay<LoginMethod>(value: .password)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorRelay = PublishRelay<String?>()
    
    //Mark: -- 转换方法
    func transform(input: Input) -> Output {
        //处理表单有效性
        let isFormValid = Observable.combineLatest(
            input.username.map { self.validateEmail($0) },
            input.password.map { !$0.isEmpty }
        ).map { $0 && $1 }
        
        //处理登录请求
        let loginRequest = input.loginTap
            .withLatestFrom(Observable.combineLatest(input.username, input.password))
            .flatMapLatest { [weak self] (username, password) -> Observable<Result<User, Error>> in
                guard let self = self else { return .empty() }
                return self.authService.login(username: username, password: password)
                    .asObservable()
                    .map { loginData -> Result<User, Error> in
                        let user = User(
                            userId: loginData.userId, 
                            username: loginData.username, 
                            email: loginData.email, 
                            avatarUrl: loginData.avatarUrl, 
                            token: loginData.token
                        )
                        return .success(user)
                    }
            }
            .share(replay: 1, scope: .whileConnected)
        
        //处理错误
        let errorMessage = loginRequest
            .map { result -> String? in
                if case .failure(let error) = result {
                    return error.localizedDescription
                }
                return nil
            }
        
        return Output(
            isLoginEnabled: isFormValid.asDriver(onErrorJustReturn: false),
            isLoading: isLoadingRelay.asDriver(),
            showRegister: .empty(),
            showPhoneLogin: .empty(),
            loginResult: loginRequest.asDriver(onErrorDriveWith: .empty()),
            errorMessage: errorMessage.asDriver(onErrorJustReturn: nil)
        )
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
