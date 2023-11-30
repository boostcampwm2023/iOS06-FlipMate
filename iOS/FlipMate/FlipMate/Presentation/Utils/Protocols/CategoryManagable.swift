//
//  CategoryManagable.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/28.
//

import Foundation
import Combine

protocol CategoryManageable {
    var categoryDidChangePublisher: AnyPublisher<[Category], Never> { get }
    func replace(categories: [Category])
    func change(category: Category)
    func removeCategory(categoryId: Int)
    func append(category: Category)
    func findCategory(categoryId: Int) -> Category?
}
