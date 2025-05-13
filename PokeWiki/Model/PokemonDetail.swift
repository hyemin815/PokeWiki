

import Foundation

struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let height: Int
    let weight: Int
}

struct PokemonTypeSlot: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
    let url: URL
}
