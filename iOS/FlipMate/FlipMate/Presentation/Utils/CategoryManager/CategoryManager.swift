//
//  CategoryManager.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/28.
//

import Foundation
import Combine

import Domain

final class CategoryManager: CategoryManageable {
    // MARK: - Properties
    private lazy var categoryDidChangeSubject = CurrentValueSubject<[StudyCategory], Never>(categories)
    private var categories: [StudyCategory] = []

    var categoryDidChangePublisher: AnyPublisher<[StudyCategory], Never> {
        return categoryDidChangeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - init
    init(categories: [StudyCategory]) {
        self.categories = categories
    }
    
    // MARK: - Methods
    func replace(categories: [StudyCategory]) {
        self.categories = categories
        categoryDidChangeSubject.send(self.categories)
    }
    
    func change(category: StudyCategory) {
        guard let targetCategory = categories.filter({ $0.id == category.id }).first else { return }
        guard let targetIndex = categories.firstIndex(of: targetCategory) else { return }
        categories[targetIndex] = category
        categoryDidChangeSubject.send(categories)
    }
    
    func removeCategory(categoryId: Int) {
        guard let targetCategory = categories.filter({ $0.id == categoryId }).first else { return }
        guard let targetIndex = categories.firstIndex(of: targetCategory) else { return }
        categories.remove(at: targetIndex)
        categoryDidChangeSubject.send(categories)
    }
    
    func append(category: StudyCategory) {
        categories.append(category)
        categoryDidChangeSubject.send(categories)
    }
    
    func findCategory(categoryId: Int) -> StudyCategory? {
        guard let targetCategory = categories.filter({ $0.id == categoryId }).first else { return nil }
        guard let targetIndex = categories.firstIndex(of: targetCategory) else { return nil }
        return categories[targetIndex]
    }
    
    func numberOfCategory() -> Int {
        return categories.count
    }
}
