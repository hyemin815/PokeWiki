

import UIKit

class ImageCell: UICollectionViewCell {
    // 나중에 ImageCell을 꺼내쓸 때 이름표
    static let id = "ImageCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .cellBackground
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // CollectionViewCell이 원래 가지고 있는 contentView에 imageView 추가
        contentView.addSubview(imageView)
        // imageView 크기와 위치를 contentView 내부 크기와 맞춤
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    // cell이 재사용 되기 전에 image nil로 초기화(이전 데이터, 이미지가 남아 있을 수 있으므로)
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}
