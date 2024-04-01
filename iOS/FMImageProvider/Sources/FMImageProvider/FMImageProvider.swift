//
//  FMImageProvider.swift
//
//
//  Created by 권승용 on 1/22/24.
//

import Foundation
import Combine

// FlipMate의 이미지 데이터 관리 및 제공 객체
public final class FMImageProvider {
    private let memoryCacher: MemoryCacheable
    private let diskCacher: DiskCacheable
    private let imageDownloader: ImageDownloadable

    /// 모듈 내부에서 접근 가능한 초기자 (테스트 코드에서 사용)
    /// - Parameters:
    ///   - memoryCacher: 메모리 캐싱을 담당하는 객체 
    ///   - diskCacher:  디스크 캐싱을 담당하는 객체
    internal init(memoryCacher: MemoryCacheable, diskCacher: DiskCacheable, imageDownloader: ImageDownloadable) {
        self.memoryCacher = memoryCacher
        self.diskCacher = diskCacher
        self.imageDownloader = imageDownloader
    }

    /// FMImageProvider 초기자
    public convenience init?() {
        let memoryStorage = NSCache<NSString, NSData>()
        let fileManager = FileManager.default
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        let session = URLSession(configuration: configuration)
        
        let memoryCacher = MemoryCacher(memoryStorage: memoryStorage)
        guard let diskCacher = DiskCacher(fileManager: fileManager) else {
            return nil
        }
        let imageDownloader = ImageDownloader(session: session)
        
        self.init(memoryCacher: memoryCacher, diskCacher: diskCacher, imageDownloader: imageDownloader)
    }
    
    /// 이미지 데이터 가져오기
    /// 가져온 이미지 데이터를 컴플리션으로 제공
    /// - Parameters:
    ///   - url: 이미지를 가져올 url 주소
    ///   - completion:이미지 데이터를 반환할 completion handler
    public func fetchImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        let key = url.absoluteString
        
        // 메모리 캐시 확인
        if let data = try? memoryCacher.load(key: key) {
            FMLogger.general.log("memory cache hit")
            completion(.success(data))
            return
        }
        
        // 디스크 캐시 확인
        if let data = try? diskCacher.load(key: key) {
            FMLogger.general.log("disk cache hit")
            memoryCacher.save(key: key, imageData: data)
            completion(.success(data))
            return
        }
        
        // 둘 다 없으면 url로부터 다운로드
        imageDownloader.fetchImage(from: url) { result in
            completion(result)
        }
    }
    
    /// 이미지 데이터 가져오기
    /// concurrency를 사용한 async 함수로 이미지 데이터 제공
    /// - Parameter url: 이미지를 가져올 url 주소
    /// - Returns: 가져온 이미지 데이터
    public func fetchImageData(from url: URL) async throws -> Data {
        let key = url.absoluteString
        
        // 메모리 캐시 확인
        if let data = try? memoryCacher.load(key: key) {
            FMLogger.general.log("memory cache hit")
            return data
        }
        
        // 디스크 캐시 확인
        if let data = try? diskCacher.load(key: key) {
            FMLogger.general.log("disk cache hit")
            memoryCacher.save(key: key, imageData: data)
            return data
        }
        
        // 둘 다 없으면 url로부터 다운로드
        let data = try await fetchImageData(from: url)
        memoryCacher.save(key: key, imageData: data)
        try diskCacher.save(key: key, imageData: data)
        return data
    }
}
