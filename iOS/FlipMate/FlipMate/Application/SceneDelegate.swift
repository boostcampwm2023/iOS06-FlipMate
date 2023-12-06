//
//  SceneDelegate.swift
//  FlipMate
//
//  Created by 권승용 on 11/9/23.
//

import UIKit
import GoogleSignIn
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var cancellables = Set<AnyCancellable>()
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        
        appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        
        appFlowCoordinator?.start()
        
        receiveSignOut()
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        _ = GIDSignIn.sharedInstance.handle(url)
    }
}

private extension SceneDelegate {
    func resetAppFlowCoordinator() {
        self.window?.rootViewController = nil
        let navigationController = UINavigationController()
        self.window?.rootViewController = navigationController
        
        appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer)
    }
    
    func receiveSignOut() {
        appDIContainer.signOutManager.signOutPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.resetAppFlowCoordinator()
                self.appFlowCoordinator?.start()
            }
            .store(in: &cancellables)
    }
}
