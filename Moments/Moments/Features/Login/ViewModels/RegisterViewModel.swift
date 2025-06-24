//
//  RegisterViewModel.swift
//  Moments
//
//  Created by wjw on 2025/6/23.
//

import Foundation
import RxSwift
import RxCocoa
import Moya


//注册 viewModel(继承基础类)
class RegisterViewModel: BaseAuthViewModel, ViewModelType {
    
    struct Input{
        let username: Observable<String>
        let email: Observable<String>
        let password: Observable<String>
        let confirmPassword: Observable<String>
        let registerTap: Observable<Void>
    }
    
    struct Output {
        //表单状态
        let isRegisterEnabled: Driver<Bool>
        
        //输入校验错误提示
        let usernameError: Driver<String?>
        let emailError: Driver<String?>
        let passwordError: Driver<String?>
        let confirmPasswordError: Driver<String?>
        
    }
    
    func transform(input: Input) -> Output {
        
        let passwordValidation = input.password
            .map { password in
                !password.isEmpty && password.count >= 4 && password.count <= 24
            }
        
        let passwordPair = Observable.combineLatest(input.password, input.confirmPassword)
        
        let isFormValid = Observable.combineLatest(
            input.username.map{ self.validateUsername($0) },
            input.email.map{ self.validateEmail($0) },
            passwordValidation,
            passwordPair
        ).map { values -> Bool in
            let (usernameValid, emailValid, passwordValid, passwords) = values
            let (password, confirmPassword) = passwords
            
            return
                usernameValid &&
                emailValid &&
                passwordValid &&
                !confirmPassword.isEmpty &&
                password == confirmPassword
        }
        
    
        // 用户名本地校验，显示到错误提示label上
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
        
        // 密码本地校验,显示到错误提示label上
        let emailError = input.email
            .map { email -> String? in
                let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let pred = NSPredicate(format: "SELF MATCHES %@", regex)
                if pred.evaluate(with: email) {
                    return nil
                } else if email.isEmpty {
                    return nil
                } else {
                    return "邮箱格式不正确"
                }
            }
            .asDriver(onErrorJustReturn: nil)
        
        // 密码本地校验,显示到错误提示label上
        let passwordError = input.password
            .map { password -> String? in
                let regex = "^[A-Za-z0-9@#$%^&+=]{4,25}$"
                let pred = NSPredicate(format: "SELF MATCHES %@", regex)
                if pred.evaluate(with: password) {
                    return nil
                } else if password.isEmpty {
                    return nil
                } else {
                    return "确认密码格式不正确"
                }
            }
            .asDriver(onErrorJustReturn: nil)
        
        // 确认密码本地校验
        let confirmPasswordError = Observable.combineLatest(input.password, input.confirmPassword) { password, confirmPassword -> String? in
            if confirmPassword.isEmpty {
                return nil
            }
            if confirmPassword.count < 4 || confirmPassword.count > 25 {
                return "确认密码格式不正确"
            }
            if password != confirmPassword {
                return "两次密码输入不一致"
            }
            return nil
        }.asDriver(onErrorJustReturn: nil)
        
        return Output(
            isRegisterEnabled: isFormValid.asDriver(onErrorJustReturn: false),
            usernameError: usernameError,
            emailError: emailError,
            passwordError: passwordError,
            confirmPasswordError: confirmPasswordError
        )
    }
    
    
    
    
}
