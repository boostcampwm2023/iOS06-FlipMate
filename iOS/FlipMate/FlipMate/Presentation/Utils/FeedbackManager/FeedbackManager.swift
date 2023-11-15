//
//  FeedbackManager.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/14.
//

import UIKit

final class FeedbackManager {
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    func startHapticFeedback(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        feedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
        feedbackGenerator?.prepare()
        feedbackGenerator?.impactOccurred()
        feedbackGenerator = nil
    }
}
