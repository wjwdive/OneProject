//
//  AuthViewController.swift
//  Moments
//
//  Created by wjw on 2025/6/18.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

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
    private let loginButton = PrimaryButton()
    private let registerButton = PrimaryButton()
    private let switchButton = UIButton()
    private let errorLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
   private var isLoginMode = true {
       didSet { updateUIForMode() }
   }
    
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
        print("isLoginMode: \(isLoginMode)")
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
        
        // 活动指示器
        activityIndicator.hidesWhenStopped = true
        
        // 创建堆栈视图
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            nameTextField,
            emailTextField,
            passwordTextField,
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
        // 利用 StackView 的自动布局特性
        nameTextField.isHidden = isLoginMode
        loginButton.isHidden = !isLoginMode
        registerButton.isHidden = isLoginMode
        
        titleLabel.text = isLoginMode ? "欢迎登录" : "创建账号"
        switchButton.setTitle(isLoginMode ? "没有账号？立即注册" : "已有账号？立即登录", for: .normal)
        
        // 强制更新布局
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
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
                self?.isLoginMode.toggle()
                self?.errorLabel.isHidden = true
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
    }
    
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
            title: isLoginMode ? "登录成功" : "注册成功",
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
}
