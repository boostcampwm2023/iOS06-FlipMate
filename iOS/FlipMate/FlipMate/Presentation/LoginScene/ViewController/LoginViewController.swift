//
//  LoginViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: - UI Components
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
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UI Setting
private extension LoginViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground

        [ googleLoginButton, appleLoginButton ].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
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
}

// MARK: - UIButton extension
fileprivate extension UIButton {
    func setLoginButton(type: LoginType) {
        self.setTitle(type.description, for: .normal)
        self.backgroundColor = .systemBackground
        self.titleLabel?.font = .systemFont(ofSize: 16)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.textColor = .black
        self.layer.cornerRadius = 11
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2.0
    }
}
