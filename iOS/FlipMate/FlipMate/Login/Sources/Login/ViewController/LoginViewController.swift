//
//  LoginViewController.swift
//
//
//  Created by 권승용 on 6/2/24.
//

import Core
import UIKit
import Combine
import GoogleSignIn
import AuthenticationServices
import DesignSystem

public final class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    private let loginViewModel: LoginViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    public init(loginViewModel: LoginViewModelProtocol) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    // MARK: - UI Components
    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "FlipMate_icon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var logoMainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.extraLargeBold.font
        label.textColor = FlipMateColor.darkBlue.color
        label.text = Constant.logoMainTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var logoSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumRegular.font
        label.textColor = FlipMateColor.gray2.color
        label.text = Constant.logoSubTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var googleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.googleLoginTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FlipMateFont.smallBold.font
        button.backgroundColor = .white
        button.layer.cornerRadius = 11
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.setShadow()
        button.addTarget(self, action: #selector(handleGoogleLoginButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(
            authorizationButtonType: .default,
            authorizationButtonStyle: .whiteOutline)
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        button.cornerRadius = 11
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setShadow()
        return button
    }()
    
    private lazy var loginSkipButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.skipLoginTitle, for: .normal)
        button.titleLabel?.font = FlipMateFont.smallRegular.font
        button.setTitleColor(FlipMateColor.gray2.color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginSkipButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - UI Setting
    public override func configureUI() {
        view.backgroundColor = .systemBackground
        
        [ logoImageView,
          logoMainTitleLabel,
          logoSubTitleLabel,
          googleLoginButton,
          appleLoginButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            
            logoMainTitleLabel.bottomAnchor.constraint(equalTo: logoSubTitleLabel.topAnchor, constant: -5),
            logoMainTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoSubTitleLabel.bottomAnchor.constraint(equalTo: logoImageView.topAnchor, constant: -50),
            logoSubTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            googleLoginButton.bottomAnchor.constraint(equalTo: appleLoginButton.topAnchor, constant: -20),
            googleLoginButton.leadingAnchor.constraint(equalTo: appleLoginButton.leadingAnchor),
            googleLoginButton.trailingAnchor.constraint(equalTo: appleLoginButton.trailingAnchor),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 44),
            
            appleLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    public override func bind() {
        loginViewModel.isMemberPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isMember in
                guard let self = self else { return }
                self.enableButtons()
                if isMember {
                    FMLogger.device.log("타이머 창으로 이동합니다")
                    loginViewModel.didFinishLoginAndIsMember()
                } else {
                    FMLogger.device.log("회원가입 창으로 이동합니다")
                    loginViewModel.didFinishLoginAndIsNotMember()
                }
            }
            .store(in: &cancellables)
        
        loginViewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                let alert = UIAlertController(title: Constant.errorOccurred, message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Constant.errorOkTitle, style: .default))
                self?.present(alert, animated: true)
                self?.enableButtons()
            }
            .store(in: &cancellables)
    }
    
    private func disableButtons() {
        DispatchQueue.main.async {
            self.googleLoginButton.isEnabled = false
            self.appleLoginButton.isEnabled = false
        }
    }
    
    private func enableButtons() {
        DispatchQueue.main.async {
            self.googleLoginButton.isEnabled = true
            self.appleLoginButton.isEnabled = true
        }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.view.window else {
            FMLogger.general.error("window is nil!!")
            return UIWindow()
        }
        return window
    }
}

// MARK: - Objc func
private extension LoginViewController {
    @objc func loginSkipButtonDidTapped() {
        loginViewModel.skippedLogin()
    }
    
    @objc func handleGoogleLoginButton() {
        disableButtons()
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, error in
            guard let self = self else { return }
            if let result = signInResult {
                let accessToken = result.user.accessToken.tokenString
                self.loginViewModel.requestGoogleLogin(accessToken: accessToken)
            } else if let error = error {
                FMLogger.device.error("\(error.localizedDescription)")
            } else {
                FMLogger.device.error("알 수 없는 에러")
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        self.disableButtons()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userID = appleIDCredential.user
            guard let token = appleIDCredential.identityToken else {
                FMLogger.general.error("토큰 비어있음!")
                return
            }
            let decodedAccessToken = String(decoding: token, as: UTF8.self)
            loginViewModel.requestAppleLogin(accessToken: decodedAccessToken, userID: userID)
        default:
            break
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 단순 취소는 오류 띄우지 않음
        if let error = error as? ASAuthorizationError {
            if error.errorCode == 1001 {
                enableButtons()
                return
            }
        }
        let alert = UIAlertController(title: Constant.errorOccurred, message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constant.errorOkTitle, style: .default))
        self.present(alert, animated: true)
        FMLogger.general.error("애플 로그인 중 에러 발생 : \(error)")
        enableButtons()
    }
}

private extension LoginViewController {
    enum Constant {
        static let logoMainTitle = "FLIP MATE"
        static let logoSubTitle = NSLocalizedString("logoSubTitle", comment: "")
        static let skipLoginTitle = NSLocalizedString("skipLoginTitle", comment: "")
        static let errorOccurred = NSLocalizedString("errorOccurred", comment: "")
        static let errorOkTitle = NSLocalizedString("ok", comment: "")
        static let googleLoginTitle = NSLocalizedString("googleLogin", comment: "")
    }
}
