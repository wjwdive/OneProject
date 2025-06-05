import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MyInfoViewController: BaseViewController {
    // MARK: - UI Components
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var userIdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var joinDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    private let viewModel: MyInfoViewModel
    
    // MARK: - Initialization
    init(userId: String = UserDataStore.current.userID) {
        print("MyInfoViewController: Initializing with userId: \(userId)")
        self.viewModel = MyInfoViewModel(userId: userId)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "个人资料"
        
        view.addSubview(avatarImageView)
        view.addSubview(infoStackView)
        view.addSubview(loadingIndicator)
        
        infoStackView.addArrangedSubview(usernameLabel)
        infoStackView.addArrangedSubview(userIdLabel)
        infoStackView.addArrangedSubview(bioLabel)
        infoStackView.addArrangedSubview(locationLabel)
        infoStackView.addArrangedSubview(joinDateLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        // 绑定用户信息
        viewModel.userInfo
            .subscribe(onNext: { [weak self] userInfo in
                guard let self = self else { return }
                self.usernameLabel.text = userInfo.username
                self.userIdLabel.text = "用户号: \(userInfo.userId)"
                
                if let createdAt = userInfo.createdAt {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy年MM月dd日"
                    self.joinDateLabel.text = "加入时间: \(formatter.string(from: createdAt))"
                }
                
                if let avatarUrl = userInfo.avatarUrl {
                    self.avatarImageView.kf.setImage(
                        with: URL(string: avatarUrl),
                        placeholder: UIImage(named: "default_avatar"),
                        options: [
                            .transition(.fade(0.3)),
                            .cacheOriginalImage
                        ]
                    )
                } else {
                    self.avatarImageView.image = UIImage(named: "default_avatar")
                }
            })
            .disposed(by: disposeBag)
        
        // 绑定加载状态
        viewModel.isLoading
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // 绑定错误处理
        viewModel.hasError
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.showError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "加载失败，请重试"]))
            })
            .disposed(by: disposeBag)
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "错误",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "重试", style: .default) { [weak self] _ in
            self?.viewModel.retry()
        })
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
}
