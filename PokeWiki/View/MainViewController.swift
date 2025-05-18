import UIKit
import SnapKit
import RxSwift

class MainViewController: UIViewController {
    
    // viewModel을 구독하기 위한 인스턴스 생성
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    // 네트워크로 받아온 PokemonList 배열 저장
    private var pokemonList = [PokemonList]()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var pokemonCollectionView: UICollectionView = {
        // 그리드형 컬렉션뷰라서 flowLayout 사용
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 125, height: 125)
        layout.sectionInset = UIEdgeInsets(top: 4, left: 2, bottom: 2, right: 2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .darkRed
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUI()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    private func bind() {
        // UI 업데이트는 메인스레드에서 실행
        viewModel.pokemonListSubject.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemonList in
                self?.pokemonList = pokemonList
                self?.pokemonCollectionView.reloadData()
            }, onError: { error in
                print("에러발생: \(error)")
            }).disposed(by: disposeBag)
        
    }
    
    private func configureUI() {
        view.backgroundColor = .mainRed
        
        logoImageView.image = UIImage(named: "pokemonBall")
        
        [
            logoImageView,
            pokemonCollectionView
        ].forEach { view.addSubview($0) }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        pokemonCollectionView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(20)
            // horizontalEdges = leading + trailing
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 선택한 셀의 포켓몬 id 가져오기
        let selectedPokemon = pokemonList[indexPath.row]
        guard let id = selectedPokemon.id else { return }
        
        // 선택한 포켓몬 id로 DetailViewController 생성 후 화면 전환
        let detailVC = DetailViewController(pokemonID: id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseIdentifier, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        
        // UI 확인용 코드
        guard indexPath.row < pokemonList.count else { return cell }
        cell.configure(with: pokemonList[indexPath.row])
        
        return cell
        
    }
    
}
