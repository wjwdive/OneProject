import UIKit

class NavBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - 子类重写方法
    func setupUI() {
        view.backgroundColor = .white
    }
    
    func bindViewModel() {
        // 子类实现具体的绑定逻辑
    }
} 