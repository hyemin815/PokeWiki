enum PokemonTypeName: String, CaseIterable, Codable {
    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy

    var displayName: String {
        switch self {
        case .normal: return "노말"
        case .fire: return "불꽃"
        case .water: return "물"
        case .electric: return "전기"
        case .grass: return "풀"
        case .ice: return "얼음"
        case .fighting: return "격투"
        case .poison: return "독"
        case .ground: return "땅"
        case .flying: return "비행"
        case .psychic: return "에스퍼"
        case .bug: return "벌레"
        case .rock: return "바위"
        case .ghost: return "고스트"
        case .dragon: return "드래곤"
        case .dark: return "어둠"
        case .steel: return "강철"
        case .fairy: return "페어리"
        }
    }
    
    static func getKoreanType(for englishType: String) -> String {
        // englishType 문자열을 enum의 case와 일치하는지 확인하고, 일치하는 displayName 값 반환
        return PokemonTypeName(rawValue: englishType.lowercased())?.displayName ?? englishType
    }
}
