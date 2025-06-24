import UIKit
import RxSwift
import RxCocoa
import SnapKit

class RegisterViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = RegisterViewModel()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "注册"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    

    private let usernameTextField = RoundedTextField()
    private let usernameErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    private let emailTextField = RoundedTextField()
    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    private let passwordTextField = RoundedTextField()
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    private let confirmPasswordTextField = RoundedTextField()
    private let confirmPasswordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("注册", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupNavigationBar()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // --- Configure Components ---
        usernameTextField.placeholder = "用户名"
        usernameTextField.keyboardType = .emailAddress
        usernameTextField.autocapitalizationType = .none
        
        emailTextField.placeholder = "邮箱"
        emailTextField.keyboardType = .emailAddress
        usernameTextField.autocapitalizationType = .none

        
        passwordTextField.placeholder = "密码"
        passwordTextField.isSecureTextEntry = true
        
        confirmPasswordTextField.placeholder = "确认密码"
        confirmPasswordTextField.isSecureTextEntry = true

        
        registerButton.setTitle("注册", for: .normal)
        
        activityIndicator.hidesWhenStopped = true
        
        // --- Layout ---
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let mainStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            usernameTextField,
            usernameErrorLabel,
            emailTextField,
            emailErrorLabel,
            passwordTextField,
            passwordErrorLabel,
            confirmPasswordTextField,
            confirmPasswordErrorLabel,
            registerButton
        ])
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        mainStackView.setCustomSpacing(24, after: confirmPasswordErrorLabel)
        mainStackView.setCustomSpacing(20, after: registerButton)
        
        contentView.addSubview(mainStackView)
        contentView.addSubview(activityIndicator)
        
        // --- Constraints with SnapKit ---
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            // Allow vertical scrolling if content is larger
            $0.height.equalToSuperview().priority(.low)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // Setup constraints using SnapKit
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalToSuperview()
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "返回",
            style: .plain,
            target: self,
            action: #selector(dismissVC)
        )
    }
    
    private func bindViewModel() {
        
        // 绑定输入
        let input = RegisterViewModel.Input(
            username: usernameTextField.rx.text.orEmpty.asObservable(),
            email: emailTextField.rx.text.orEmpty.asObservable(),
            password: passwordTextField.rx.text.orEmpty.asObservable(),
            confirmPassword: confirmPasswordTextField.rx.text.orEmpty.asObservable(),
            registerTap: registerButton.rx.tap.asObservable()
        )
        //获取输出
        let output = viewModel.transform(input: input)
        
        output.isRegisterEnabled
            .drive(registerButton.rx.isEnabled)
            .disposed(by: disposeBag)

        output.usernameError
            .drive(usernameErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.emailError
            .drive(emailErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.passwordError
            .drive(passwordErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.confirmPasswordError
            .drive(confirmPasswordErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        // Bind viewModel outputs
//        viewModel.registerSuccess
//            .subscribe(onNext: { [weak self] response in
//                // Handle successful registration
//                print("Registration successful: \(user.name)")
//                self?.dismiss(animated: true)
//            })
//            .disposed(by: disposeBag)
//        
//        viewModel.error
//            .subscribe(onNext: { [weak self] error in
//                self?.showAlert(message: error)
//            })
//            .disposed(by: disposeBag)
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
} 
