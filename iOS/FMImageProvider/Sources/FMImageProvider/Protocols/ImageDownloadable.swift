//
//  ImageDownloadable.swift
//
//
//  Created by 권승용 on 1/23/24.
//

import Foundation

protocol ImageDownloadable {
    func fetchImage(from url: URL, completion: @escaping (Result<Data, Error>) -> ())
    @available (iOS 15, *)
    func fetchImage(from url: URL) async throws -> Data
}
