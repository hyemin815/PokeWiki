

import Foundation

struct PokemonListResponse: Codable {
    let count: Int
    let results: [PokemonList]
}

struct PokemonList: Codable {
    let name: String
    let url: URL
}
