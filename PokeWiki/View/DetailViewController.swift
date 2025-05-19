import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    // DetailViewModel은 생성 시 pokemonID가 필요한데, init 전에는 ID를 모르기 때문에 선언만 해둠
    private var viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkRed
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    // 초기화 시 pokemonID를 받아서 DetailViewModel 인스턴스 생성
    init(pokemonID: Int) {
        self.viewModel = DetailViewModel(pokemonID: pokemonID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUI()
    }
    
        private func bind() {
            // label 텍스트 업데이트
            viewModel.nameSubject
                // 영어이름을 한국 이름으로 변환, 데이터 가공 후 메인 스레드에서 작업할 수 있도록 observe 위에 작성
                .map { PokemonTranslator.getKoreanName(for: $0) }
                .observe(on: MainScheduler.instance)
                // nameLabel.text에 바인딩
                .bind(to: nameLabel.rx.text)
                .disposed(by: disposeBag)
            
            viewModel.typeSubject
                .map { PokemonTypeName.getKoreanType(for: $0)}
                .observe(on: MainScheduler.instance)
                .bind(to: typeLabel.rx.text)
                .disposed(by: disposeBag)
            
            viewModel.heightSubject
                .observe(on: MainScheduler.instance)
                .bind(to: heightLabel.rx.text)
                .disposed(by: disposeBag)
            
            viewModel.weightSubject
                .observe(on: MainScheduler.instance)
                .bind(to: weightLabel.rx.text)
                .disposed(by: disposeBag)

            // 포켓몬 이미지 업데이트
            let urlString =  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(viewModel.pokemonID).png"
            guard let url = URL(string: urlString) else { return }
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.pokemonImageView.image = image
                        }
                    }
                }
            }
        }
    
        private func configureUI() {
            view.backgroundColor = .mainRed
            
            [
                cardView
            ].forEach { view.addSubview($0)}
            
            cardView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.equalToSuperview().offset(30)
                $0.trailing.equalToSuperview().offset(-30)
            }
            
            [
                pokemonImageView,
                nameLabel,
                typeLabel,
                heightLabel,
                weightLabel
            ].forEach { cardView.addSubview($0) }
            
            pokemonImageView.snp.makeConstraints {
                $0.top.equalTo(cardView.snp.top).offset(30)
                $0.leading.equalTo(cardView.snp.leading).offset(50)
                $0.trailing.equalTo(cardView.snp.trailing).offset(-50)
                $0.height.equalTo(150)
            }
            
            nameLabel.snp.makeConstraints {
                $0.top.equalTo(pokemonImageView.snp.bottom).offset(10)
                $0.centerX.equalToSuperview()
            }
            
            typeLabel.snp.makeConstraints {
                $0.top.equalTo(nameLabel.snp.bottom).offset(10)
                $0.centerX.equalToSuperview()
            }
            
            heightLabel.snp.makeConstraints {
                $0.top.equalTo(typeLabel.snp.bottom).offset(10)
                $0.centerX.equalToSuperview()
            }
            
            weightLabel.snp.makeConstraints {
                $0.top.equalTo(heightLabel.snp.bottom).offset(10)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-20)
            }
        }
    }
