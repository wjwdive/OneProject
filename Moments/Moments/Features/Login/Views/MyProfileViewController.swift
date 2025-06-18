//
//  ProfileViewController.swift
//  Moments
//
//  Created by wjw on 2025/6/18.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - 个人资料视图控制器
class MyProfileViewController: UIViewController {
    private let user: User
    
    private let avatarView = UIView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 头像
        avatarView.backgroundColor = .systemGray5
        avatarView.layer.cornerRadius = 60
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        let avatarLabel = UILabel()
        avatarLabel.text = String(user.username.prefix(1))
        avatarLabel.font = UIFont.boldSystemFont(ofSize: 36)
        avatarLabel.textColor = .systemBlue
        avatarLabel.textAlignment = .center
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        
        avatarView.addSubview(avatarLabel)
        
        // 用户信息
        nameLabel.text = user.username
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        
        emailLabel.text = user.email
        emailLabel.textColor = .systemGray
        emailLabel.textAlignment = .center
        
        // 登出按钮
        logoutButton.setTitle("退出登录", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        // 堆栈视图
        let stackView = UIStackView(arrangedSubviews: [
            avatarView, nameLabel, emailLabel, logoutButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // 布局约束
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            avatarView.widthAnchor.constraint(equalToConstant: 120),
            avatarView.heightAnchor.constraint(equalToConstant: 120),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func logoutTapped() {
        dismiss(animated: true)
    }
}
