import UIKit

class DiscoverViewController: NavBaseViewController {
    
    private let viewModel: DiscoverViewModel
    
    init(viewModel: DiscoverViewModel = DiscoverViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        title = "发现"
        tabBarItem = UITabBarItem(title: "发现", 
                                 image: UIImage(systemName: "safari"), 
                                 selectedImage: UIImage(systemName: "safari.fill"))
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        // 实现具体的绑定逻辑
        viewModel.onFeaturesUpdated = { [weak self] in
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