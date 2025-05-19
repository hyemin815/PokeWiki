
import Foundation

// 에러 정의
enum NetworkError: Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
}
