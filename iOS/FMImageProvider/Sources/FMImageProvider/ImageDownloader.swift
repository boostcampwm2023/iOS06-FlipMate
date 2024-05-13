//
//  ImageDownloader.swift
//  
//
//  Created by 권승용 on 1/22/24.
//
import Foundation

final class ImageDownloader: ImageDownloadable {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    /// 주어진 url로부터 이미지 데이터를 다운로드해 반환하는 함수
    /// 컴플리션 핸들러를 사용
    /// - Parameters:
    ///   - url: 이미지 URL
    ///   - completion: 결과를 받는 컴플리션 핸들러.
    ///   정상적인 결과를 반환받는다면 이미지 Data와 nil을 매개변수로 받는다.
    ///   에러가 있다면 nil과 에러를 매개변수로 받는다.
    func fetchImage(from url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        let request = URLRequest(url: url)
        let downloadTask = session.dataTask(with: request) { dataOrNil, responseOrNil, errorOrNil in // status code 에러에 대응하기
            if let error = errorOrNil {
                completion(.failure(error))
                return
            }
            guard let data = dataOrNil else {
                completion(.failure(FMImageProviderError.ImageDownloaderError.noData))
                return
            }
            completion(.success(data))
        }
        
        downloadTask.resume()
    }
    
    /// 주어진 url로부터 이미지 데이터를 다운로드해 반환하는 함수
    /// concurrency를 사용
    /// - Parameter url: 이미지 URL
    /// - Returns: 다운로드 받은 이미지 데이터
    func fetchImage(from url: URL) async throws -> Data {
        let (data, _) = try await session.data(from: url) // status code 에러에 대응하기
        return data
    }
}
