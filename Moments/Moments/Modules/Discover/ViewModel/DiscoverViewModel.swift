import Foundation

class DiscoverViewModel: BaseViewModel {
    // 发现页功能列表
    private(set) var features: [DiscoverFeature] = []
    
    // 数据更新回调
    var onFeaturesUpdated: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeatures()
    }
    
    private func loadFeatures() {
        isLoading = true
        // TODO: 实现功能列表加载逻辑
        // 模拟数据
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.features = [
                DiscoverFeature(id: "1", title: "朋友圈", icon: "photo.on.rectangle"),
                DiscoverFeature(id: "2", title: "视频号", icon: "video"),
                DiscoverFeature(id: "3", title: "扫一扫", icon: "qrcode.viewfinder")
            ]
            self?.isLoading = false
            self?.onFeaturesUpdated?()
        }
    }
} 