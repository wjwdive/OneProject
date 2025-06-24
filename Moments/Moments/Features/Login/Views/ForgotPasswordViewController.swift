import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ForgotPasswordViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "找回密码"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
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
    
    private let submitButton = PrimaryButton()
    private let backToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("返回登录", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        emailTextField.placeholder = "请输入注册邮箱"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        submitButton.setTitle("提交", for: .normal)
        activityIndicator.hidesWhenStopped = true
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            emailTextField,
            emailErrorLabel,
            submitButton,
            backToLoginButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        submitButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupActions() {
        backToLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        // 其他绑定和校验逻辑可根据实际需求补充
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "返回",
            style: .plain,
            target: self,
            action: #selector(dismissVC)
        )
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
