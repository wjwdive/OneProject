import Foundation

class ProfileViewModel: BaseViewModel {
    // 用户信息
    private(set) var userInfo: UserInfo?
    
    // 数据更新回调
    var onUserInfoUpdated: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    
    private func loadUserInfo() {
        isLoading = true
        // TODO: 实现用户信息加载逻辑
        // 模拟数据
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.userInfo = UserInfo(
                id: "1",
                name: "张三",
                avatar: nil,
                phone: "13800138000",
                email: "zhangsan@example.com"
            )
            self?.isLoading = false
            self?.onUserInfoUpdated?()
        }
    }
} 