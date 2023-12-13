//
//  LoginViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

import UIKit
import Combine
import GoogleSignIn
import AuthenticationServices

final class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    private let loginViewModel: LoginViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Constant
    private enum Constant {
        static let logoMainTitle = "FLIP MATE"
        static let logoSubTitle = NSLocalizedString("logoSubTitle", comment: "")
        static let skipLoginTitle = NSLocalizedString("skipLoginTitle", comment: "")
    }
    
    // MARK: - Init
    init(loginViewModel: LoginViewModelProtocol) {
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
        button.setLoginButton(type: .google)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleGoogleLoginButton), for: .touchUpInside)
        return button
    }()

    private var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(
            authorizationButtonType: .default,
            authorizationButtonStyle: .black)
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
    override func configureUI() {
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
    
    override func bind() {
        loginViewModel.isMemberPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isMember in
                guard let self = self else { return }
                if let isMember = isMember {
                    if isMember {
                        FMLogger.device.log("타이머 창으로 이동합니다")
                        loginViewModel.didFinishLoginAndIsMember()
                    } else {
                        FMLogger.device.log("회원가입 창으로 이동합니다")
                        loginViewModel.didFinishLoginAndIsNotMember()
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Objc func
private extension LoginViewController {
    @objc func loginSkipButtonDidTapped() {
        loginViewModel.skippedLogin()
    }
    
    @objc func handleGoogleLoginButton() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, error in
            guard let self = self else { return }
            if let result = signInResult {
                let accessToken = result.user.accessToken.tokenString
                self.loginViewModel.requestLogin(accessToken: accessToken)
            } else if let error = error {
                FMLogger.device.error("\(error.localizedDescription)")
            } else {
                FMLogger.device.error("알 수 없는 에러")
            }
        }
    }
}

// MARK: - UIButton extension
fileprivate extension UIButton {
    func setLoginButton(type: LoginType) {
        self.setTitle(type.buttonTitle, for: .normal)
        self.backgroundColor = .systemBackground
        self.titleLabel?.font = FlipMateFont.smallRegular.font
        self.setTitleColor(.label, for: .normal)
        self.layer.cornerRadius = 11
        self.layer.borderWidth = 1.0
        self.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        self.setShadow()
    }
}
