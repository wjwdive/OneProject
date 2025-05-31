import Foundation

class ChatViewModel: BaseViewModel {
    // 聊天列表数据
    private(set) var chatList: [ChatItem] = []
    
    // 数据更新回调
    var onChatListUpdated: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChatList()
    }
    
    private func loadChatList() {
        isLoading = true
        // TODO: 实现聊天列表加载逻辑
        // 模拟数据
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.chatList = [
                ChatItem(id: "1", name: "张三", lastMessage: "你好", time: Date()),
                ChatItem(id: "2", name: "李四", lastMessage: "在吗？", time: Date())
            ]
            self?.isLoading = false
            self?.onChatListUpdated?()
        }
    }
} 