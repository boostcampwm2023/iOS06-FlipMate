//
//  SocialViewModel.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/30.
//

import Foundation
import Combine

struct SocialViewModelActions {
    var showFriendAddViewController: () -> Void
}

protocol SocialViewModelInput {
    func viewWillAppear()
    func freindAddButtonDidTapped()
}

protocol SocialViewModelOutput {
    var freindsPublisher: AnyPublisher<[Friend], Never> { get }
}

typealias SocialViewModelProtocol = SocialViewModelInput & SocialViewModelOutput

final class SocialViewModel: SocialViewModelProtocol {
    // MARK: - Subject
    private var freindsSubject = PassthroughSubject<[Friend], Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let actions: SocialViewModelActions?
    private let socialUseCase: SocialUseCase
    
    // MARK: - init
    init(actions: SocialViewModelActions? = nil, socialUseCase: SocialUseCase) {
        self.actions = actions
        self.socialUseCase = socialUseCase
    }
    
    // MARK: - Output
    var freindsPublisher: AnyPublisher<[Friend], Never> {
        return freindsSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Input
    func freindAddButtonDidTapped() {
        actions?.showFriendAddViewController()
    }
    
    func viewWillAppear() {
        socialUseCase.getMyFriend(date: Date())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    FMLogger.friend.debug("친구 받아오기 성공")
                case .failure(let error):
                    FMLogger.friend.error("친구 받아오기 에러 발생 \(error)")
                }
            } receiveValue: { [weak self] freinds in
                guard let self = self else { return }
                self.freindsSubject.send(freinds)
            }
            .store(in: &cancellables)

    }
}
