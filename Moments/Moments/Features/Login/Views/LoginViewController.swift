import UIKit
import RxSwift
import RxCocoa
import SnapKit

class LoginViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var viewModel = LoginViewModel()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "欢迎登录"
        label.font = .systemFont(ofSize: 32, weight: .bold)
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
    
    private let passwordTextField = RoundedTextField()
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    private let loginButton = PrimaryButton()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("没有账号？立即注册", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("忘记密码？", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // --- Configure Components ---
        usernameTextField.placeholder = "用户名或邮箱"
        usernameTextField.keyboardType = .emailAddress
        usernameTextField.autocapitalizationType = .none
        
        passwordTextField.placeholder = "密码"
        passwordTextField.isSecureTextEntry = true
        
        loginButton.setTitle("登录", for: .normal)
        
        activityIndicator.hidesWhenStopped = true
        
        // --- Layout ---
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let linksStackView = UIStackView(arrangedSubviews: [registerButton, forgotPasswordButton])
        linksStackView.axis = .horizontal
        linksStackView.distribution = .equalSpacing
        
        let mainStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            usernameTextField,
            usernameErrorLabel,
            passwordTextField,
            passwordErrorLabel,
            loginButton,
            linksStackView
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        mainStackView.setCustomSpacing(24, after: passwordErrorLabel)
        mainStackView.setCustomSpacing(20, after: loginButton)
        
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
        
        usernameTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        loginButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        let input = LoginViewModel.Input(
            username: usernameTextField.rx.text.orEmpty.asObservable(),
            password: passwordTextField.rx.text.orEmpty.asObservable(),
            loginTap: loginButton.rx.tap.asObservable()
        )
        //获取输出
        let output = viewModel.transform(input: input)
        
        //绑定输出到UI
        output.isLoginEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(usernameErrorLabel.rx.text)
            .disposed(by: disposeBag)
        

        registerButton.rx.tap.subscribe(onNext: { [weak self] in
            // Navigate to register screen
            let registerVC = RegisterViewController() // Assuming this exists
            self?.navigationController?.pushViewController(registerVC, animated: true)
        }).disposed(by: disposeBag)

//        viewModel.usernameError
//            .drive(usernameErrorLabel.rx.text)
//            .disposed(by: disposeBag)
//            
//        viewModel.usernameError
//            .map { $0 == nil }
//            .drive(usernameErrorLabel.rx.isHidden)
//            .disposed(by: disposeBag)
//        
    }
}

