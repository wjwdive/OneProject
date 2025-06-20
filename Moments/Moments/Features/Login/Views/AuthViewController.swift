//
//  AuthViewController.swift
//  Moments
//
//  Created by wjw on 2025/6/18.
//

/**
    以一种很不优雅的方式完成登录注册
    每一种状态都会声明并维护一个控制变量流
 
 */

import Foundation
import RxSwift
import RxCocoa
import SnapKit


// MARK: - 登录注册视图控制器
class AuthViewController: UIViewController {
    private let viewModel = AuthViewModel()
    private let disposeBag = DisposeBag()
    
    // 视图元素
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let nameTextField = RoundedTextField()
    private let emailTextField = RoundedTextField()
    private let passwordTextField = RoundedTextField()
    private let confirmPasswordTextField = RoundedTextField()
    private let loginButton = PrimaryButton()
    private let registerButton = PrimaryButton()
    private let switchButton = UIButton()
    private let errorLabel = UILabel()
    private let usernameErrorLabel = UILabel()
    private let emailErrorLabel = UILabel()
    private let passwordErrorLabel = UILabel()
    private let confirmPasswordErrorLabel = UILabel()

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupKeyboardHandling()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("nameTextField isUserInteractionEnabled: \(nameTextField.isUserInteractionEnabled)")
        print("nameTextField isEnabled: \(nameTextField.isEnabled)")
        print("nameTextField isHidden: \(nameTextField.isHidden)")
        print("nameTextField frame: \(nameTextField.frame)")

        print("=== 调试信息 ===")
        print("isLoginMode: \(viewModel.isLoginMode)")
        print("nameTextField isHidden: \(nameTextField.isHidden)")
        print("emailTextField isHidden: \(emailTextField.isHidden)")
        print("passwordTextField isHidden: \(passwordTextField.isHidden)")
        print("loginButton isHidden: \(loginButton.isHidden)")
        print("registerButton isHidden: \(registerButton.isHidden)")
        print("switchButton isHidden: \(switchButton.isHidden)")
        print("loginButton frame: \(loginButton.frame)")
        print("registerButton frame: \(registerButton.frame)")
        print("switchButton frame: \(switchButton.frame)")
        print("==================")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 配置滚动视图
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 标题
        titleLabel.text = "欢迎登录"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        // 文本输入框
        nameTextField.placeholder = "用户名"
        nameTextField.autocapitalizationType = .none
        nameTextField.isHidden = true
        
        emailTextField.placeholder = "邮箱"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none

        passwordTextField.placeholder = "密码"
        passwordTextField.isSecureTextEntry = true
        
        confirmPasswordTextField.placeholder = "确认密码"
        confirmPasswordTextField.isSecureTextEntry = true


        // 按钮
        loginButton.setTitle("登录", for: .normal)
        registerButton.setTitle("注册", for: .normal)
        registerButton.isHidden = true
        
        switchButton.setTitle("没有账号？立即注册", for: .normal)
        switchButton.setTitleColor(.systemBlue, for: .normal)
        switchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        // 错误标签
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        
        usernameErrorLabel.text = "用户名需不少于5位且只能包含字母和数字"
        emailErrorLabel.text = "请使用国内主流邮箱"
        passwordErrorLabel.text = "用户名需不少于4位且只能包含字母和数字"
        confirmPasswordErrorLabel.text = "确认密码"

        // 配置错误提示label
        [usernameErrorLabel, emailErrorLabel, passwordErrorLabel, confirmPasswordErrorLabel].forEach { label in
            label.textColor = .systemRed
            label.font = UIFont.systemFont(ofSize: 12)
            label.numberOfLines = 0
            label.isHidden = true
        }
        
        // 活动指示器
        activityIndicator.hidesWhenStopped = true
        
        // 创建堆栈视图
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            nameTextField,
            usernameErrorLabel,   // 用户名下方
            emailTextField,
            emailErrorLabel,      // 邮箱下方
            passwordTextField,
            passwordErrorLabel,   // 密码下方
            confirmPasswordTextField,
            confirmPasswordErrorLabel,   // 确认密码下方
            loginButton,
            registerButton,
            switchButton,
            errorLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加视图到层级
        contentView.addSubview(stackView)
        contentView.addSubview(activityIndicator)
        
        // 使用 SnapKit 设置约束
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        // 设置输入框和按钮的高度约束
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }

        confirmPasswordTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        registerButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        switchButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        updateUIForMode()
    }
    
    private func updateUIForMode() {
        // 切换时
        viewModel.isLoginMode.accept(!viewModel.isLoginMode.value)
        
        // 利用 StackView 的自动布局特性
        //登录模式下隐藏所有注册相关输入框和提示
        nameTextField.isHidden = viewModel.isLoginMode.value
        usernameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = viewModel.isLoginMode.value
        passwordErrorLabel.isHidden = viewModel.isLoginMode.value
        confirmPasswordTextField.isHidden = viewModel.isLoginMode.value
        confirmPasswordErrorLabel.isHidden = viewModel.isLoginMode.value

        loginButton.isHidden = !viewModel.isLoginMode.value
        registerButton.isHidden = viewModel.isLoginMode.value
        
        titleLabel.text = viewModel.isLoginMode.value ? "欢迎登录" : "创建账号"
        switchButton.setTitle(viewModel.isLoginMode.value  ? "没有账号？立即注册" : "已有账号？立即登录", for: .normal)
        
        // 强制更新布局
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupBindings() {
        // 绑定输入到 ViewModel
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        // 绑定按钮点击
        loginButton.rx.tap
            .bind(to: viewModel.loginTap)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind(to: viewModel.registerTap)
            .disposed(by: disposeBag)
        
        switchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.isLoginMode.accept(!self.viewModel.isLoginMode.value)
                self.errorLabel.isHidden = true
                // 隐藏所有错误提示
                self.usernameErrorLabel.isHidden = true
                self.emailErrorLabel.isHidden = true
                self.passwordErrorLabel.isHidden = true
                self.confirmPasswordErrorLabel.isHidden = true
            })
            .disposed(by: disposeBag)
        
        // 绑定加载状态
        viewModel.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .map { !$0 }
            .bind(to: loginButton.rx.isEnabled, registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 绑定错误消息
        viewModel.errorMessage
            .subscribe(onNext: { [weak self] message in
                self?.errorLabel.text = message
                self?.errorLabel.isHidden = false
                self?.showErrorAnimation()
            })
            .disposed(by: disposeBag)
        
        // 绑定认证结果
        viewModel.authResult
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let user):
                    self?.handleAuthSuccess(user: user)
                case .failure(let error):
                    self?.handleAuthError(error: error)
                }
            })
            .disposed(by: disposeBag)

        // 用户名长度和格式
        viewModel.isUsernameLengthValid
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isValid in
                self?.usernameErrorLabel.isHidden = isValid
                if !isValid {
                    self?.usernameErrorLabel.text = "用户名需不少于5位且只能包含字母和数字"
                }
            })
            .disposed(by: disposeBag)
        
        // 用户名可用性校验（网络）
        viewModel.isUsernameValid
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] isAvailable in 
            self?.usernameErrorLabel.isHidden = isAvailable
            if !isAvailable {
                self?.usernameErrorLabel.text = "用户名已存在"
            }else {
                self?.usernameErrorLabel.text = "用户名可用"
            }
        })
        .disposed(by: disposeBag)

        // 邮箱格式
        viewModel.isEmailFormatValid
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] isvalid in 
            self?.emailErrorLabel.isHidden = isvalid
            if !isvalid {
                self?.emailErrorLabel.text = "请输入正确的邮箱格式"
            }
        })
        .disposed(by: disposeBag)

        // 邮箱可用性
       viewModel.isEmailValid
        .observeOn(MainScheduler.instance)
       .subscribe(onNext: {[weak self] isAvailable in 
            self?.emailErrorLabel.isHidden = isAvailable
            if !isAvailable {
                self?.emailErrorLabel.text = "邮箱已存在"
            }else {
                self?.usernameErrorLabel.text = "邮箱可用"
            }
       })
       .disposed(by: disposeBag)

        // 密码
    viewModel.isPasswordValid
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { [weak self] isValid in
        self?.passwordErrorLabel.isHidden = isValid
        if !isValid {
            self?.passwordErrorLabel.text = "密码不能少于4位"
        }
    })
    .disposed(by: disposeBag)


    // 确认密码错误提示
    viewModel.shouldShowConfirmPasswordError
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { [weak self] shouldShow in
        self?.confirmPasswordErrorLabel.isHidden = !shouldShow
        if shouldShow {
            self?.confirmPasswordErrorLabel.text = "两次密码输入不一致"
        }
    })
    .disposed(by: disposeBag)

    // 监听两次密码是否一致
let confirmPasswordValid = Observable
    .combineLatest(viewModel.password, viewModel.confirmPassword) { $0 == $1 && !$1.isEmpty }

// 只在注册模式下才显示
Observable
            .combineLatest(confirmPasswordValid, (viewModel.isLoginMode).asObservable()) { isValid, isLogin in
        return !isValid && !isLogin
    }
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { [weak self] shouldShow in
        self?.confirmPasswordErrorLabel.isHidden = !shouldShow
        if shouldShow {
            self?.confirmPasswordErrorLabel.text = "两次密码输入不一致"
        }
    })
    .disposed(by: disposeBag)

    // 响应式绑定 isLoginMode，动态更新 UI
    viewModel.isLoginMode.asObservable()
        .subscribe(onNext: { [weak self] isLogin in
            self?.updateUIForMode(isLoginMode: isLogin)
        })
        .disposed(by: disposeBag)
        
}
    
    //错误动画
    private func showErrorAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.errorLabel.transform = CGAffineTransform(translationX: 10, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.errorLabel.transform = CGAffineTransform(translationX: -10, y: 0)
            }, completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.errorLabel.transform = .identity
                }
            })
        })
    }
    
    private func handleAuthSuccess(user: User) {
        errorLabel.isHidden = true
        
        let alert = UIAlertController(
            title: viewModel.isLoginMode.value ? "登录成功" : "注册成功",
            message: "欢迎回来，\(user.username)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak self] _ in
            self?.showProfileScreen(user: user)
        }))
        
        present(alert, animated: true)
    }
    
    private func handleAuthError(error: AuthError) {
        errorLabel.isHidden = true
        
        let alert = UIAlertController(
            title: "请求错误",
            message: error.description,
            preferredStyle: .alert
        )
        present(alert, animated: true)
    }
    
    private func showProfileScreen(user: User) {
        let profileVC = MyProfileViewController(user: user)
        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: true)
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let self = self else { return }
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                
                let keyboardHeight = keyboardFrame.height
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                self.scrollView.contentInset = contentInsets
                self.scrollView.scrollIndicatorInsets = contentInsets
                
                // 如果有活动文本字段，滚动到可见位置
                if let activeField = [self.nameTextField, self.emailTextField, self.passwordTextField].first(where: { $0.isFirstResponder }) {
                    let rect = activeField.convert(activeField.bounds, to: self.scrollView)
                    self.scrollView.scrollRectToVisible(rect, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.scrollView.contentInset = .zero
                self?.scrollView.scrollIndicatorInsets = .zero
            })
            .disposed(by: disposeBag)
    }

    private func updateUIForMode(isLoginMode: Bool) {

        if isLoginMode {
            nameTextField.isHidden = !isLoginMode
            emailTextField.isHidden = true
            passwordTextField.isHidden = !isLoginMode
            confirmPasswordTextField.isHidden = true
        }else {
            nameTextField.isHidden = false
            emailTextField.isHidden = false
            passwordTextField.isHidden = false
            confirmPasswordTextField.isHidden = false
        }


        loginButton.isHidden = !isLoginMode
        registerButton.isHidden = isLoginMode

        titleLabel.text = isLoginMode ? "欢迎登录" : "创建账号"
        switchButton.setTitle(isLoginMode ? "没有账号？立即注册" : "已有账号？立即登录", for: .normal)

        // 隐藏所有错误提示
        usernameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true

        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
    }
}




// MARK: - 自定义 UI 组件
class RoundedTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class PrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .systemBlue
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        layer.cornerRadius = 8
        contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .systemBlue : .systemGray
        }
    }
}
