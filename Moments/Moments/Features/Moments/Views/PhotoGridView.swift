import UIKit
import Kingfisher

final class PhotoGridView: UIView {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero//设置 CollectionView 的 sectionInset 为 .zero，确保没有额外的内边距
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        return collectionView
    }()
    
    private var photoURLs: [URL] = []
    private var itemSize: CGSize = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(0) // 设置初始高度为0
        }
    }
    
    func configure(with urls: [URL]) {
        photoURLs = urls
        isHidden = urls.isEmpty
        
        // 计算item大小
        let itemCount = min(urls.count, 9)
        if itemCount > 0 {
            let spacing: CGFloat = 4
            let availableWidth = max(bounds.width, 0)  // 确保宽度不为负
            let itemsPerRow: CGFloat
            let rows: CGFloat
            
            switch itemCount {
            case 1:
                itemsPerRow = 1
                rows = 1
            case 2:
                itemsPerRow = 2
                rows = 1  // 2张图片时只有1行
            case 3:
                itemsPerRow = 3
                rows = 1
            case 4:
                itemsPerRow = 2  // 4张图片时2x2排列
                rows = 2
            default:
                itemsPerRow = 3
                rows = ceil(CGFloat(itemCount) / itemsPerRow)  // 其他情况根据图片数量计算行数
            }
            
            // 确保间距计算不会导致负值
            let totalSpacing = max(spacing * (itemsPerRow - 1), 0)
            let itemWidth = max((availableWidth - totalSpacing) / itemsPerRow, 0)
            
            // 计算总高度，当只有一行时不计算行间距
            let rowSpacing = rows > 1 ? spacing * (rows - 1) : 0
            let totalHeight = max((itemWidth * rows) + rowSpacing, 0)
            
            print("itemCount: \(itemCount), rows: \(rows), itemWidth: \(itemWidth), totalHeight: \(totalHeight)")
            
            // 设置CollectionView的高度约束
            collectionView.snp.updateConstraints {
                $0.height.equalTo(totalHeight.rounded(.up))
            }
            
            itemSize = CGSize(width: itemWidth, height: itemWidth)
            
            // 强制更新布局
            collectionView.layoutIfNeeded()
        } else {
            // 如果没有图片，设置高度为0
            collectionView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        }
        
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !photoURLs.isEmpty {
            configure(with: photoURLs)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoGridView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(photoURLs.count, 9)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.configure(with: photoURLs[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoGridView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    //代理方法，确保间距设置一致：
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

// MARK: - PhotoCell
private class PhotoCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with url: URL) {
        imageView.kf.setImage(with: url)
    }
} 
