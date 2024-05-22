//
//  CategoryManagable.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/28.
//

import Foundation
import Combine

import Domain

protocol CategoryManageable {
    var categoryDidChangePublisher: AnyPublisher<[StudyCategory], Never> { get }
    func replace(categories: [StudyCategory])
    func change(category: StudyCategory)
    func removeCategory(categoryId: Int)
    func append(category: StudyCategory)
    func findCategory(categoryId: Int) -> StudyCategory?
    func numberOfCategory() -> Int
}
