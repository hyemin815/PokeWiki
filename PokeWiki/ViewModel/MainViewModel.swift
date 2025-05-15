

import Foundation
import RxSwift

class MainViewModel {

    private var disposeBag = DisposeBag()
    
    // view가 구독할 수 있도록 subject 생성
    let pokemonListSubject = BehaviorSubject(value: [PokemonList]())
    let pokemonDetailSubject = BehaviorSubject(value: [PokemonDetailResponse]() )
    
    // 임의값 지정
    var pokemonID = 1
    
    // viewModel이 생성되자마자 데이터를 자동으로 불러오기 위해 init에서 함수 호출
    init() {
        fetchPokemonList()
        fetchPokemonDetail()
    }
    
    // viewModel에서 수행해야할 비즈니스 로직
    func fetchPokemonList() {
        // URL 타입 변환 시도해서 nil이면 error 방출
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0") else {
            pokemonListSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        // NetworkManager의 fetch 메서드 구독
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: PokemonListResponse) in
                self?.pokemonListSubject.onNext(response.results)
            }, onFailure: { [weak self] error in
                self?.pokemonListSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func fetchPokemonDetail() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID)/") else {
            pokemonDetailSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: PokemonDetailResponse) in
                self?.pokemonDetailSubject.onNext(response)
            }, onFailure: { [weak self] error in
                self?.pokemonDetailSubject.onError(error)
            }).disposed(by: disposeBag)
        
    }
}
