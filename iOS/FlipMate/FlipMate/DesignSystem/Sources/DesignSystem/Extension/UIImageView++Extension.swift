//
//  UIImageView++Extension.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/05.
//

import UIKit
import FMImageProvider

extension UIImageView {
    private func downLoadImage(with url: URL) async throws {
        let image = try await FMImageProvider.shared.fetchImageData(from: url)
        self.image = UIImage(data: image)
    }
    
    public func setImage(url: String?) {
        Task {
            do {
                guard let imageURL = URL(string: url ?? "") else {
                    self.image = UIImage(resource: .defaultProfile)
                    return
                }
                try await self.downLoadImage(with: imageURL)
            } catch {
                self.image = UIImage(resource: .defaultProfile)
            }
        }
    }
}
