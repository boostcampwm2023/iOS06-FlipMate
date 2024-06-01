//
//  File.swift
//  
//
//  Created by 권승용 on 5/31/24.
//

import Foundation
import Combine
import Domain

public protocol CategoryManageable {
    var categoryDidChangePublisher: AnyPublisher<[StudyCategory], Never> { get }
    func replace(categories: [StudyCategory])
    func change(category: StudyCategory)
    func removeCategory(categoryId: Int)
    func append(category: StudyCategory)
    func findCategory(categoryId: Int) -> StudyCategory?
    func numberOfCategory() -> Int
}

public final class CategoryManager: CategoryManageable {
    // MARK: - Properties
    private lazy var categoryDidChangeSubject = CurrentValueSubject<[StudyCategory], Never>(categories)
    private var categories: [StudyCategory] = []
    
    public var categoryDidChangePublisher: AnyPublisher<[StudyCategory], Never> {
        return categoryDidChangeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - init
    public init(categories: [StudyCategory]) {
        self.categories = categories
    }
    
    // MARK: - Methods
    public func replace(categories: [StudyCategory]) {
        self.categories = categories
        categoryDidChangeSubject.send(self.categories)
    }
    
    public func change(category: StudyCategory) {
        guard let targetCategory = categories.filter({ $0.id == category.id }).first else { return }
        guard let targetIndex = categories.firstIndex(of: targetCategory) else { return }
        categories[targetIndex] = category
        categoryDidChangeSubject.send(categories)
    }
    
    public func removeCategory(categoryId: Int) {
        guard let targetCategory = categories.filter({ $0.id == categoryId }).first else { return }
        guard let targetIndex = categories.firstIndex(of: targetCategory) else { return }
        categories.remove(at: targetIndex)
        categoryDidChangeSubject.send(categories)
    }
    
    public func append(category: StudyCategory) {
        categories.append(category)
        categoryDidChangeSubject.send(categories)
    }
    
    public func findCategory(categoryId: Int) -> StudyCategory? {
        guard let targetCategory = categories.filter({ $0.id == categoryId }).first else { return nil }
        guard let targetIndex = categories.firstIndex(of: targetCategory) else { return nil }
        return categories[targetIndex]
    }
    
    public func numberOfCategory() -> Int {
        return categories.count
    }
}
