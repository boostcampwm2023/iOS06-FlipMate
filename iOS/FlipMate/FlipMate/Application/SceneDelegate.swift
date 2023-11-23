//
//  SceneDelegate.swift
//  FlipMate
//
//  Created by 권승용 on 11/9/23.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = LoginViewController(loginViewModel: LoginViewModel(googleAuthUseCase: DefaultGoogleAuthUseCase(repository: DefaultGoogleAuthRepository(provider: Provider(urlSession: URLSession.shared)))))
        window.makeKeyAndVisible()
        try? KeychainManager.deleteAccessToken()
        
        self.window = window
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        let _ = GIDSignIn.sharedInstance.handle(url)
    }
}

