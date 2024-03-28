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
        let downloadTask = session.downloadTask(with: url) { urlOrNil, responseOrNil, errorOrNil in // status code 에러에 대응하기
            guard let fileURL = urlOrNil else {
                completion(.failure(FMImageProviderError.ImageDownloaderError.noURL))
                return
            }
            do {
                let data = try Data(contentsOf: fileURL)
                try FileManager.default.removeItem(at: fileURL)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
        
        downloadTask.resume()
    }
    
    /// 주어진 url로부터 이미지 데이터를 다운로드해 반환하는 함수
    /// concurrency를 사용
    /// - Parameter url: 이미지 URL
    /// - Returns: 다운로드 받은 이미지 데이터
    @available (iOS 15, *)
    func fetchImage(from url: URL) async throws -> Data {
        let (fileURL, _) = try await session.download(from: url, delegate: nil) // status code 에러에 대응하기
        let data = try Data(contentsOf: fileURL)
        try FileManager.default.removeItem(at: fileURL)
        return data
    }
}
