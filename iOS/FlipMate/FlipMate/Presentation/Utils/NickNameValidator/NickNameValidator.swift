//
//  NickNameValidator.swift
//  FlipMate
//
//  Created by 권승용 on 11/29/23.
//

import Foundation

protocol NickNameValidatable {
    func checkNickNameValidationState(_ nickName: String) -> NickNameValidationState
}

final class NickNameValidator: NickNameValidatable {
    func checkNickNameValidationState(_ nickName: String) -> NickNameValidationState {
        enum Constant {
            static let maxLenght = 10
            static let minLength = 2
        }
        
        if nickName.containsEmoji {
            return NickNameValidationState.emojiContained
        }
        
        if nickName.count > Constant.maxLenght {
            return NickNameValidationState.lengthViolation
        }
        
        if nickName.isEmpty || nickName.count < Constant.minLength {
            return NickNameValidationState.emptyViolation
        }
        
        // TODO: FlipMate 서비스에 맞는 다양한  닉네임 제약조건 검사
        return NickNameValidationState.valid
    }
}

enum NickNameValidationState {
    case valid
    case lengthViolation
    case emptyViolation
    case duplicated
    case emojiContained
    
    var message: String {
        switch self {
        case .valid:
            return NSLocalizedString("available", comment: "")
        case .lengthViolation:
            return NSLocalizedString("lengthViolation", comment: "")
        case .emptyViolation:
            return NSLocalizedString("emptyViolation", comment: "")
        case .duplicated:
            return NSLocalizedString("duplicated", comment: "")
        case .emojiContained:
            return NSLocalizedString("emojiContained", comment: "")
        }
    }
}

extension Character {
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else {
            return false
        }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    var isCombinedIntoEmoji: Bool {
        unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    }
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var containsEmoji: Bool {
        return contains { $0.isEmoji }
    }
}
