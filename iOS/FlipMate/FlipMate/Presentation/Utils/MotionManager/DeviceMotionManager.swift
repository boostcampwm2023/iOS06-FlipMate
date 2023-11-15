//
//  MotionManager.swift
//  FlipMate
//
//  Created by 신민규 on 11/15/23.
//

import UIKit
import CoreMotion

final class DeviceMotionManager {
    static let shared = DeviceMotionManager()
    static let orientationDidChangeNotification = Notification.Name("orientationDidChangeNotification")
    
    private let motion: CMMotionManager
    private(set) var orientation: UIDeviceOrientation {
        didSet {
            guard oldValue != orientation else { return }
            NotificationCenter.default.post(name: DeviceMotionManager.orientationDidChangeNotification, object: self)
        }
    }
    
    private init() {
        self.motion = CMMotionManager()
        self.orientation = .unknown
    }
    
    func startDeviceMotion() {
        guard self.motion.isDeviceMotionAvailable else { return }
        
        self.motion.deviceMotionUpdateInterval = 0.1
        self.motion.startDeviceMotionUpdates(to: OperationQueue()) { (data, error) in
            guard error == nil, let gravityData = data?.gravity else { return }
            
            if abs(gravityData.z) > 0.9 {
                self.orientation = gravityData.z < 0 ? .faceUp : .faceDown
            } else if abs(gravityData.x) < 0.33 {
                self.orientation = gravityData.y < 0 ? .portrait : .portraitUpsideDown
            } else if abs(gravityData.y) < 0.33 {
                self.orientation = gravityData.x < 0 ? .landscapeLeft : .landscapeRight
            } else {
                self.orientation = .unknown
            }
        }
    }
    
    func stopDeviceMotion() {
        self.motion.stopDeviceMotionUpdates()
    }
}


