
import Foundation
import RxSwift

class DetailViewModel {
    
    private var disposeBag = DisposeBag()
    let pokemonID: Int
    
    let nameSubject = BehaviorSubject<String>(value: "")
    let typeSubject = BehaviorSubject<String>(value: "")
    let heightSubject = BehaviorSubject<String>(value: "")
    let weightSubject = BehaviorSubject<String>(value: "")
    
    // ViewController에서 pokemonID를 전달받아야 함
    init(pokemonID: Int) {
        self.pokemonID = pokemonID
        fetchPokemonDetail()
    }
    
    func fetchPokemonDetail() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID)/") else {
            // error를 방출하면 스트림이 종료되므로 "Error" 텍스트 값 방출
            nameSubject.onNext("Error")
            typeSubject.onNext("Error")
            heightSubject.onNext("Error")
            weightSubject.onNext("Error")
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: PokemonDetailResponse) in
                
                // 한국어로 번역
                let name = response.name
                let koreanName = PokemonTranslator.getKoreanName(for: name)
                self?.nameSubject.onNext("No.\(self?.pokemonID ?? 0) \(koreanName)")

                let typeName = response.types.first?.type.name ?? ""
                let koreanTypeName = PokemonTypeName.getKoreanType(for: typeName)
                self?.typeSubject.onNext("타입: \(koreanTypeName)")
                
                self?.heightSubject.onNext("키: \(Double(response.height) / 10.0) m")
                self?.weightSubject.onNext("몸무게: \(Double(response.weight) / 10.0) kg")
            }, onFailure: { [weak self] _ in
                self?.nameSubject.onNext("Error")
                self?.typeSubject.onNext("Error")
                self?.heightSubject.onNext("Error")
                self?.weightSubject.onNext("Error")
            }).disposed(by: disposeBag)
    }
}

