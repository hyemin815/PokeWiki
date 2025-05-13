
import Foundation
import RxSwift

class NetworkManager {
    // 싱글톤
    static let shared = NetworkManager()
    
    // 외부에서 NetworkManager를 생성하지 못하도록 private init
    private init() {}
    
    // URL 타입의 매개변수 url을 받아서 하나의 값을 방출
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            
            // 네트워크 요청을 보낼 URLSession 인스턴스 생성
            let session = URLSession(configuration: .default)
            
            // URL 요청을 보내고 응답 데이터를 받아옴
            session.dataTask(with: URLRequest(url: url)) { data, response, error in
                
                // URLSession 콜백에서 넘어온 error가 nil이 아니면 error 상수에 넣고
                if let error = error {
                    // Single 스트림에 실패 이벤트로 error 전달 후 함수 종료
                    observer(.failure(error))
                    return
                }
                
                // 3가지 조건을 만족하지 못하면 dataFetchFail error 전달 후 함수 종료
                guard let data = data,
                      // response의 타입은 URLResponse로 넘어오기 때문에 statusCode를 쓰기 위해서 HTTPURLResonse로 타입캐스팅
                      let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.dataFetchFail))
                    return
                }
                
                // 콜백으로 받은 data를 T 타입으로 디코딩
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    // 디코딩 성공하면 success 이벤트로 decodedData 값 전달
                    observer(.success(decodedData))
                } catch {
                    // 실패하면 decodingFail 값 전달
                    observer(.failure(NetworkError.decodingFail))
                }
            // dataTask는 초기화만 해주고 바로 실행되지 않으므로 resume 호출
            }.resume()
            
            // 구독 해제가 가능한 옵저버블 생성
            return Disposables.create()
            }
        }
    }
