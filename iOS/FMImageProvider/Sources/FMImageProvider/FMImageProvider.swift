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
    public convenience init?(memoryCapacity: Int = 1_000_000_000, diskCapacity: Int = 1_000_000_000) async {
        let memoryStorage = NSCache<NSString, NSData>()
        let fileManager = FileManager.default
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        let session = URLSession(configuration: configuration)
        
        let memoryCacher = MemoryCacher(memoryStorage: memoryStorage, capacity: memoryCapacity)
        guard let diskCacher = await DiskCacher(fileManager: fileManager, capacity: diskCapacity) else {
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
        Task {
            let key = url.absoluteString
            
            // 메모리 캐시 확인
            if let data = try? memoryCacher.load(key: key) {
                FMLogger.general.log("memory cache hit")
                completion(.success(data))
                return
            }
            
            // 디스크 캐시 확인
            do {
                if let data = try await diskCacher.load(key: key) {
                    FMLogger.general.log("disk cache hit")
                    memoryCacher.save(key: key, imageData: data)
                    completion(.success(data))
                    return
                }
            } catch {
                try await diskCacher.removeAll()
            }
            
            // 둘 다 없으면 url로부터 다운로드
            imageDownloader.fetchImage(from: url) { result in
                switch result {
                case .success(let data):
                    Task {
                        do {
                            print("메모리 및 디스크 캐셔에 저장")
                            self.memoryCacher.save(key: key, imageData: data)
                            try await self.diskCacher.save(key: key, imageData: data)
                        } catch let error {
                            FMLogger.general.error("Disk Cache Save Failed: \(error)")
                        }
                    }
                case .failure:
                    break
                }
                completion(result)
            }
        }
    }
    
    /// 이미지 데이터 가져오기
    /// concurrency를 사용한 async 함수로 이미지 데이터 제공
    /// - Parameter url: 이미지를 가져올 url 주소
    /// - Returns: 가져온 이미지 데이터
    @available(iOS 15.0, *)
    public func fetchImageData(from url: URL) async throws -> Data {
        let key = url.absoluteString
        
        // 메모리 캐시 확인
        if let data = try? memoryCacher.load(key: key) {
            FMLogger.general.log("memory cache hit")
            return data
        }
        
        // 디스크 캐시 확인
        do {
            if let data = try await diskCacher.load(key: key) {
                FMLogger.general.log("disk cache hit")
                memoryCacher.save(key: key, imageData: data)
                return data
            }
        } catch {
            try await diskCacher.removeAll()
        }
        
        // 둘 다 없으면 url로부터 다운로드
        let data = try await imageDownloader.fetchImage(from: url)
        memoryCacher.save(key: key, imageData: data)
        try await diskCacher.save(key: key, imageData: data)
        return data
    }
    
    /// 저장된 캐시 지우기
    public func clearAllCaches() async throws {
        memoryCacher.removeAll()
        try await diskCacher.removeAll()
    }
}
