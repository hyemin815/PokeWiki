

import UIKit

class CardCell: UICollectionViewCell {
    // 나중에 ImageCell을 꺼내쓸 때 이름표
    static let reuseIdentifier = "CardCell"
    
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
    
    // 데이터를 받아서 Cell을 구성
    func configure(with pokemonImage: PokemonList) {
        // PokemonList의 id 값 가져와서 사용
        guard let id = pokemonImage.id else { return }
        let urlString =  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        guard let url = URL(string: urlString) else { return }
        
        // 이미지 다운로드 같은 무거운 작업은 백그라운드에서 작업
        DispatchQueue.global().async { [weak self] in
            // url에 있는 이미지 데이터 다운로드 시도
            if let data = try? Data(contentsOf: url) {
                // data를 이미지로 변환 시도, 에러를 던지지 않기 때문에 try? 불필요
                if let image = UIImage(data: data) {
                    
                    // 다운받은 이미지 업데이트는 main 스레드에서 작업
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
}


