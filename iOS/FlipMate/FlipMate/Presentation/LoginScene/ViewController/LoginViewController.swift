//
//  LoginViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

import UIKit

final class LoginViewController: UIViewController {
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
    }
}
