import UIKit

class ProfileViewController: NavBaseViewController {
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        title = "我"
        tabBarItem = UITabBarItem(title: "我", 
                                 image: UIImage(systemName: "person.circle"), 
                                 selectedImage: UIImage(systemName: "person.circle.fill"))
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        // 实现具体的绑定逻辑
        viewModel.onUserInfoUpdated = { [weak self] in
            // TODO: 更新UI
        }
        
        viewModel.onLoadingChanged = { [weak self] isLoading in
            // TODO: 处理加载状态
        }
        
        viewModel.onError = { [weak self] error in
            // TODO: 处理错误
        }
    }
} 