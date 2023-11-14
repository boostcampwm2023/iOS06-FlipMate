//
//  TimerViewModel.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/14.
//

import Foundation
import Combine

protocol TimerViewModelInput {
    func UIDeviceOrientationDidChange(_ sender: Int)
    func UIDeviceProximityDidChange(_ sender: Bool)
    func categorySettingButtoneDidTapped()
}

protocol TimerViewModelOutput {
    var isDeviceFaceDownPublisher: AnyPublisher<Bool, Never> { get }
    var isPresentingCategoryPublisher: AnyPublisher<Void, Never> { get }
}

typealias TimerViewModelProtocol = TimerViewModelInput & TimerViewModelOutput

final class TimerViewModel: TimerViewModelProtocol {
    
    // MARK: Properties
    private var orientation: Int?
    private var proximity: Bool?
    private var isDeviceFaceDownSubject = PassthroughSubject<Bool, Never>()
    private var isPresentingCategorySubject = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    var isDeviceFaceDownPublisher: AnyPublisher<Bool, Never> {
        return isDeviceFaceDownSubject.eraseToAnyPublisher()
    }
    var isPresentingCategoryPublisher: AnyPublisher<Void, Never> {
        return isPresentingCategorySubject.eraseToAnyPublisher()
    }
    
    // MARK: Input
    func UIDeviceOrientationDidChange(_ sender: Int) {
        orientation = sender
        sendFaceDownStatus()
    }
    
    func UIDeviceProximityDidChange(_ sender: Bool) {
        proximity = sender
        sendFaceDownStatus()
    }
    
    func categorySettingButtoneDidTapped() {
        isPresentingCategorySubject.send(Void())
    }
}

// MARK: Private Methods
private extension TimerViewModel {
    
    /// 화면이 뒤집어져있는지 판단해 그 결과를 Output으로 전달합니다
    func sendFaceDownStatus() {
        if orientation == 6 && proximity == true {
            isDeviceFaceDownSubject.send(true)
        } else {
            isDeviceFaceDownSubject.send(false)
        }
    }
}
