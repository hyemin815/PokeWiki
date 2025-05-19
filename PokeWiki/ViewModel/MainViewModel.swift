

import Foundation
import RxSwift

class MainViewModel {
    
    private var offset = 0
    // 현재 데이터 로딩 중인지 확인하는 코드, true일 때 중복 요청을 방지해서 스크롤 시 여러번 API 호출하는 것을 막고, 호출되면 다시 false로 변경
    private var isLoading = false
    // 지금까지 받아온 포켓몬 데이터를 저장하는 배열
    private var allPokemon = [PokemonList]()
    
    private var disposeBag = DisposeBag()
    
    // view가 구독할 수 있도록 subject 생성, 초기값은 PokemonList 타입을 요소로 갖는 빈 배열
    let pokemonListSubject = BehaviorSubject(value: [PokemonList]())
    
    // viewModel이 생성되자마자 데이터를 자동으로 불러오기 위해 init에서 함수 호출
    init() {
        fetchPokemonList()
    }
    
    // viewModel에서 수행해야할 비즈니스 로직
    func fetchPokemonList() {
        // isLoading이 true일 경우 로딩 중이므로 함수 종료
        guard !isLoading else { return }
        // false일 경우 isLoading을 true로 변경하고 데이터 불러오기
        isLoading = true
        
        // URL 타입 변환 시도해서 nil이면 error 방출
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=\(offset)") else {
            pokemonListSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        // NetworkManager의 fetch 메서드 구독
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: PokemonListResponse) in
                // 화면이 사라질 경우 self가 nil이 될 수 있으므로 self가 살아있을 때만 실행
                guard let self = self else { return }
                self.offset += 20
                // 기존 배열에 API로 받은 결과 값 추가
                self.allPokemon += response.results
                // 최신 포켓몬리스트를 pokemonListSubject로 방출
                self.pokemonListSubject.onNext(self.allPokemon)
                // 데이터 로딩이 종료되어 값 false로 초기화
                self.isLoading = false
            }, onFailure: { [weak self] error in
                self?.pokemonListSubject.onError(error)
                self?.isLoading = false
            }).disposed(by: disposeBag)
    }
}
