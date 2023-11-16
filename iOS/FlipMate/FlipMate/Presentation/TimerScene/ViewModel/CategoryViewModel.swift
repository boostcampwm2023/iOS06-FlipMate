//
//  CategoryViewModel.swift
//  FlipMate
//
//  Created by 신민규 on 11/16/23.
//

import Foundation
import Combine

protocol CategoryViewModelInput {
    func addCategory(_ sender: Category)
    func removeCategory(_ sender: Int)
}

protocol CategoryViewModelOutput {
    var categoriesPublisher: AnyPublisher<[Category], Never> { get }
}

typealias CategoryViewModelProtocol = CategoryViewModelInput & CategoryViewModelOutput

final class CategoryViewModel: CategoryViewModelProtocol {
    
    // MARK: properties
    private var categoriesSubject = CurrentValueSubject<[Category], Never>([])
    
    // MARK: Output
    var categoriesPublisher: AnyPublisher<[Category], Never> {
        return categoriesSubject.eraseToAnyPublisher()
    }
    
    // MARK: Input
    func addCategory(_ sender: Category) {
        var currentCategories = categoriesSubject.value
        currentCategories.append(sender)
        categoriesSubject.send(currentCategories)
    }
    
    func removeCategory(_ sender: Int) {
        var currentCategories = categoriesSubject.value
        guard currentCategories.indices.contains(sender) else { return }
        currentCategories.remove(at: sender)
        categoriesSubject.send(currentCategories)
    }
}
