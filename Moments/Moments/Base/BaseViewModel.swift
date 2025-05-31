import Foundation

class BaseViewModel {
    // 基础属性和方法
    var isLoading: Bool = false {
        didSet {
            onLoadingChanged?(isLoading)
        }
    }
    
    var onLoadingChanged: ((Bool) -> Void)?
    
    // 错误处理
    var error: Error? {
        didSet {
            onError?(error)
        }
    }
    
    var onError: ((Error?) -> Void)?
    
    // 生命周期方法
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
    func viewDidDisappear() {}
} 