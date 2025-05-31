import UIKit

class RootNavigationController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupAppearance()
        // 设置默认选中第一个标签（聊天）
        selectedIndex = 0
    }
    
    private func setupViewControllers() {
        let chatVC = UINavigationController(rootViewController: ChatViewController())
        let contactsVC = UINavigationController(rootViewController: ContactsViewController())
        let discoverVC = UINavigationController(rootViewController: DiscoverViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        // 设置 tabBar 图标
        chatVC.tabBarItem = UITabBarItem(
            title: "聊天",
            image: UIImage(systemName: "message")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "message.fill")?.withRenderingMode(.alwaysTemplate)
        )
        
        contactsVC.tabBarItem = UITabBarItem(
            title: "通讯录",
            image: UIImage(systemName: "person.2")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "person.2.fill")?.withRenderingMode(.alwaysTemplate)
        )
        
        discoverVC.tabBarItem = UITabBarItem(
            title: "发现",
            image: UIImage(systemName: "safari")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "safari.fill")?.withRenderingMode(.alwaysTemplate)
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "我",
            image: UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysTemplate)
        )
        
        viewControllers = [chatVC, contactsVC, discoverVC, profileVC]
    }
    
    private func setupAppearance() {
        // 设置 tabBar 外观
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        // 设置未选中状态的颜色为白色
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        
        // 设置选中状态的颜色为系统蓝色
        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        
        // 应用外观设置
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        // 设置导航栏外观
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = .systemBackground
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    }
} 
