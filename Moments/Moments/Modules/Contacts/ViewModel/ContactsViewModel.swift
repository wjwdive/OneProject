import Foundation

class ContactsViewModel: BaseViewModel {
    // 联系人列表数据
    private(set) var contacts: [Contact] = []
    
    // 按首字母分组的联系人数据
    private(set) var groupedContacts: [(String, [Contact])] = []
    
    // 数据更新回调
    var onContactsUpdated: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
    }
    
    private func loadContacts() {
        isLoading = true
        // TODO: 实现联系人列表加载逻辑
        // 模拟数据
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.contacts = [
                Contact(id: "1", name: "张三", avatar: nil, phone: "13800138001", email: "zhangsan@example.com", department: "技术部", position: "工程师"),
                Contact(id: "2", name: "李四", avatar: nil, phone: "13800138002", email: "lisi@example.com", department: "产品部", position: "产品经理"),
                Contact(id: "3", name: "王五", avatar: nil, phone: "13800138003", email: "wangwu@example.com", department: "设计部", position: "设计师")
            ]
            self?.groupContacts()
            self?.isLoading = false
            self?.onContactsUpdated?()
        }
    }
    
    private func groupContacts() {
        // 按首字母分组
        let grouped = Dictionary(grouping: contacts) { $0.pinyinInitial }
        groupedContacts = grouped.sorted { $0.key < $1.key }
    }
    
    // 搜索联系人
    func searchContacts(query: String) {
        guard !query.isEmpty else {
            groupContacts()
            onContactsUpdated?()
            return
        }
        
        let filtered = contacts.filter { contact in
            contact.name.contains(query) ||
            (contact.phone?.contains(query) ?? false) ||
            (contact.email?.contains(query) ?? false)
        }
        
        let grouped = Dictionary(grouping: filtered) { $0.pinyinInitial }
        groupedContacts = grouped.sorted { $0.key < $1.key }
        onContactsUpdated?()
    }
} 