

import Foundation

struct PokemonListResponse: Codable {
    let count: Int
    let results: [PokemonList]
}

struct PokemonList: Codable {
    let name: String
    let url: URL
    
    // id를 추출하기 위한 계산 프로퍼티
    var id: Int? {
        // pathComponents: URL 타입 속성으로 URL 경로를 / 기준으로 잘라서 배열로 반환
        Int(url.lastPathComponent)
    }
}
