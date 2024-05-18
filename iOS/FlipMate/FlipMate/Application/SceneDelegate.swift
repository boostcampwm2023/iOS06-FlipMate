//
//  SceneDelegate.swift
//  FlipMate
//
//  Created by 권승용 on 11/9/23.
//

import Core
import UIKit
import GoogleSignIn
import AuthenticationServices
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var cancellables = Set<AnyCancellable>()
    let keychainManager = KeychainManager()
    
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
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        guard let userID = try? keychainManager.getAppleUserID() else {
            FMLogger.general.error("키체인으로부터 애플 유저 아이디 가져오기 실패")
            return
        }
        
        appleIDProvider.getCredentialState(forUserID: userID) { [weak self] credentialState, error in
            guard let self = self else { return }
            if error != nil {
                FMLogger.general.error("애플 credential 가져오는 중 오류 - \(error)")
                return
            }
            switch credentialState {
            case .authorized:
                FMLogger.appLifeCycle.log("sceneDidBecomeActive - 애플 로그인 인증 성공")
            case .revoked:
                FMLogger.appLifeCycle.log("sceneDidBecomeActive - 애플 로그인 인증 만료")
                self.signOut()
            case .notFound:
                FMLogger.appLifeCycle.log("sceneDidBecomeActive - 애플 Credential을 찾을 수 없음")
            default:
                break
            }
        }
    }
    
    private func signOut() {
        NotificationCenter.default.post(name: NotificationName.signOut, object: nil)
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
        NotificationCenter.default.publisher(for: NotificationName.signOut)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                try? keychainManager.deleteAccessToken()
                try? keychainManager.deleteAppleUserID()
                appDIContainer.userInfoManager.initManager()
                
                resetAppFlowCoordinator()
                appFlowCoordinator?.start()
            }
            .store(in: &cancellables)
    }
}
