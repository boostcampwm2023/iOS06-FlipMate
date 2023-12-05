//
//  MyPageViewController.swift
//  FlipMate
//
//  Created by 권승용 on 11/30/23.
//

import UIKit

final class MyPageViewController: BaseViewController {
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.titleLabel?.font = FlipMateFont.largeBold.font
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func configureUI() {
        let subviews = [
            logoutButton
        ]
        
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    func logoutButtonTapped() {
        _ = try? KeychainManager.deleteAccessToken()
//        exit(0)
    }
}
