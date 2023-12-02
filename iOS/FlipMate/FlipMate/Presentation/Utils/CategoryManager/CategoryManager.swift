//
//  CategoryManager.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/28.
//

import Foundation
import Combine

final class CategoryManager: CategoryManageable {
    // MARK: - Properties
    private lazy var categoryDidChangeSubject = CurrentValueSubject<[Category], Never>(categories)
    private var categories: [Category] = []

    var categoryDidChangePublisher: AnyPublisher<[Category], Never> {
        return categoryDidChangeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - init
    init(categories: [Category]) {
        self.categories = categories
    }
    
    // MARK: - Methods
    func replace(categories: [Category]) {
        self.categories = categories
        categoryDidChangeSubject.send(self.categories)
    }
    
    func change(category: Category) {
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
    
    func append(category: Category) {
        categories.append(category)
        categoryDidChangeSubject.send(categories)
    }
    
    func findCategory(categoryId: Int) -> Category? {
        guard let targetCategory = categories.filter({ $0.id == categoryId }).first else { return nil }
        guard let targetIndex = categories.firstIndex(of: targetCategory) else { return nil }
        return categories[targetIndex]
    }
}
