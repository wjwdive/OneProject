import UIKit

class ChatViewController: NavBaseViewController {
    
    private let viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel = ChatViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        title = "聊天"
        tabBarItem = UITabBarItem(title: "聊天", 
                                 image: UIImage(systemName: "message"), 
                                 selectedImage: UIImage(systemName: "message.fill"))
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        // 实现具体的绑定逻辑
        viewModel.onChatListUpdated = { [weak self] in
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