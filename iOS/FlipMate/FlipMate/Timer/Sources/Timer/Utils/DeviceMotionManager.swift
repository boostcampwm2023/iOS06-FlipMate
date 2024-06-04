//
//  DeviceMotionManager.swift
//
//
//  Created by 권승용 on 5/31/24.
//

import UIKit
import CoreMotion
import Combine

final class DeviceMotionManager {
    static let shared = DeviceMotionManager()
    
    private let motion: CMMotionManager
    private(set) var orientation: UIDeviceOrientation
    private(set) var orientationDidChangePublisher = PassthroughSubject<UIDeviceOrientation, Never>()
    
    private init() {
        self.motion = CMMotionManager()
        self.orientation = .unknown
    }
    
    func startDeviceMotion() {
        guard self.motion.isDeviceMotionAvailable else { return }
        
        self.motion.deviceMotionUpdateInterval = 0.1
        self.motion.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] (data, error) in
            guard let self = self, error == nil, let gravityData = data?.gravity else { return }
            
            var newOrientation: UIDeviceOrientation = .unknown
            
            if abs(gravityData.z) > 0.9 {
                newOrientation = gravityData.z < 0 ? .faceUp : .faceDown
            } else if abs(gravityData.x) < 0.33 {
                newOrientation = gravityData.y < 0 ? .portrait : .portraitUpsideDown
            } else if abs(gravityData.y) < 0.33 {
                newOrientation = gravityData.x < 0 ? .landscapeLeft : .landscapeRight
            } else {
                newOrientation = .unknown
            }
            
            if newOrientation != self.orientation {
                self.orientationDidChangePublisher.send(newOrientation)
                self.orientation = newOrientation
            }
        }
    }
    
    func stopDeviceMotion() {
        self.motion.stopDeviceMotionUpdates()
    }
}
