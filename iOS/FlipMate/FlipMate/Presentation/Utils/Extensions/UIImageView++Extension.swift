//
//  UIImageView++Extension.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/05.
//

import UIKit

extension UIImageView {
    func downLoadImage(with url: String) async throws {
        let image = try await ImageDownLoader.shared.image(from: url)
        self.image = image
    }
    
    func setImage(url: String?) {
        Task {
            do {
                guard let imageURL = url else {
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
