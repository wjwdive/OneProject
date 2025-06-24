//
//  BaseAuthViewModel.swift
//  Moments
//
//  Created by wjw on 2025/6/23.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

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
    
    // 本地验证用户名格式
    func validateUsername(_ username: String) -> Bool {
        let regex = "^[A-Za-z0-9]{5,25}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: username)
    }
    
    // 邮箱格式验证（符合RFC 5322标准）
    func validateEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: email)
    }

    // 中国大陆手机号验证（11位，1开头，第二位3-9）
    func validatePhone(_ phone: String) -> Bool {
        let regex = "^1[3-9]\\d{9}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: phone)
    }
    
}
