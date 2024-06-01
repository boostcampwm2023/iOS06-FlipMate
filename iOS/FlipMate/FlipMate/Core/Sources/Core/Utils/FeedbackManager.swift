//
//  FeedbackManager.swift
//
//
//  Created by 권승용 on 5/31/24.
//

import Foundation
import CoreHaptics

public final class FeedbackManager {
    public static let shared = FeedbackManager()
    private var engine: CHHapticEngine!
    private var supportsHaptics: Bool = false
    
    // MARK: - init
    private init() {
        createEngine()
        checkHapticsCompatibility()
        configureResetHandler()
        configureStoppedHandler()
    }
    
    // MARK: - Configure Haptic Engine
    private func createEngine() {
        do {
            engine = try CHHapticEngine()
        } catch let error {
            assertionFailure("Enging Creation Error: \(error)")
        }
    }
    
    private func checkHapticsCompatibility() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics
    }
    
    private func configureResetHandler() {
        engine.resetHandler = {
            FMLogger.device.log("Reset Handler: 햅틱 엔진 재시작")
            do {
                try self.engine.start()
            } catch {
                assertionFailure("엔진 재시작 실패")
            }
        }
    }
    
    private func configureStoppedHandler() {
        engine.stoppedHandler = { reason in
            FMLogger.device.debug("Stop Handler: 햅틱 엔진 정지: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt:
                break
            case .applicationSuspended:
                break
            case .idleTimeout:
                break
            case .systemError:
                break
            case .notifyWhenFinished:
                break
            case .engineDestroyed:
                break
            case .gameControllerDisconnect:
                break
            @unknown default:
                break
            }
        }
    }
    
    // MARK: - Haptic Feedback Playbacks
    private func playHapticsFile(named fileName: String) {
        if !supportsHaptics {
            return
        }
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "ahap") else {
            return
        }
        
        do {
            try engine?.start()
            try engine?.playPattern(from: URL(fileURLWithPath: path))
        } catch { // Engine startup errors
            FMLogger.device.error("An error occured playing \(fileName): \(error).")
        }
    }
    
    // MARK: - Haptic Feedback Situations
    public func startFacedownFeedback() {
        playHapticsFile(named: "FaceDown")
    }
    
    public func startFaceupFeedback() {
        playHapticsFile(named: "FaceDown")
    }
    
    public func startTabBarItemTapFeedback() {
        playHapticsFile(named: "Selection")
    }
    
    // TODO: 탭 이동 등 다른 부분에서도 햅틱 피드백 적용해보기
}
