//
//  ImageFetcher.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/05.
//

import UIKit

struct ImageFetcher {
    static let shared = ImageFetcher()
    private init() {}
    
    func fetchImage(with url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ImageDownLoaderError.statusCodeError
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageDownLoaderError.unSupportImage
        }
        
        return image
    }
}
