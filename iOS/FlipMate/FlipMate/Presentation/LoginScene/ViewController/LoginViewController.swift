//
//  LoginViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    // MARK: - Constant
    private enum Constant {
        static let logoMainTitle = "FLIP MATE"
        static let logoSubTitle = "우리들이 공부하는 시간"
        static let skipLoginTitle = "로그인하지 않고 이용하기"
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
        label.font = FlipMateFont.largeBold.font
        label.textColor = FlipMateColor.darkBlue.color
        label.text = Constant.logoMainTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var logoSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.smallBold.font
        label.textColor = FlipMateColor.gray2.color
        label.text = Constant.logoSubTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var googleLoginButton: UIButton = {
        let button = UIButton()
        button.setLoginButton(type: .google)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var appleLoginButton: UIButton = {
        let button = UIButton()
        button.setLoginButton(type: .apple)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Setting
    override func configureUI() {
        view.backgroundColor = .systemBackground

        [ logoImageView,
          logoMainTitleLabel,
          logoSubTitleLabel,
          googleLoginButton,
          appleLoginButton,
          loginSkipButton ].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
            logoMainTitleLabel.bottomAnchor.constraint(equalTo: logoSubTitleLabel.topAnchor, constant: -5),
            logoMainTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoSubTitleLabel.bottomAnchor.constraint(equalTo: logoImageView.topAnchor, constant: -20),
            logoSubTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            googleLoginButton.bottomAnchor.constraint(equalTo: appleLoginButton.topAnchor, constant: -20),
            googleLoginButton.leadingAnchor.constraint(equalTo: appleLoginButton.leadingAnchor),
            googleLoginButton.trailingAnchor.constraint(equalTo: appleLoginButton.trailingAnchor),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 44),
            
            appleLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 44),
            
            loginSkipButton.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 20),
            loginSkipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

// MARK: - Objc func
private extension LoginViewController {
    // TODO: Condinator 패턴 도입 !?
    @objc func loginSkipButtonDidTapped() {
        let tabBarViewController = TabBarViewController()
        tabBarViewController.modalPresentationStyle = .fullScreen
        view.window?.rootViewController = tabBarViewController
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
