//
//  ImageDownLoader.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/05.
//

import UIKit

actor ImageDownLoader {
    static let shared = ImageDownLoader()
    private init() {}
    
    private var cache: [URL: UIImage] = [:]
    
    func image(from urlPath: String) async throws -> UIImage? {
        guard let url = URL(string: urlPath) else { throw ImageDownLoaderError.invalidURLString }
                
        if let cached = cache[url] {
            return cached
        }
        
        let image = try await downloadImage(from: url)
        
        cache[url] = cache[url, default: image]
        
        return cache[url]
        
    }
    
    private func downloadImage(from url: URL) async throws -> UIImage {
        let imageFetchProvider = ImageFetcher.shared
        return try await imageFetchProvider.fetchImage(with: url)
    }
}
