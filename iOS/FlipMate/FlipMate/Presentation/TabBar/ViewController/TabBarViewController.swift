//
//  TabBarViewController.swift
//  FlipMate
//
//  Created by 신민규 on 11/13/23.
//

import UIKit

final class TabBarViewController: UITabBarController {

    private enum Constant {
        static let timerImageName = "timer"
        static let borderWidth: CGFloat = 1.0
        static let timerImageSize: CGFloat = 40
    }
    
    lazy var timerButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = Constant.borderWidth
        button.backgroundColor = FlipMateColor.tabBarColor.color
        button.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        button.tintColor = FlipMateColor.gray2.color
        button.addTarget(self, action: #selector(timerButtonAction(sender:)), for: .touchUpInside)
        button.setShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: Constant.timerImageName,
                                withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: Constant.timerImageSize))),
                                     for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrame()
        setUpTimerButton()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tabBar.layer.backgroundColor = FlipMateColor.tabBarColor.color?.cgColor
        tabBar.layer.borderColor = FlipMateColor.tabBarLayerColor.color?.cgColor
    }
}

// MARK: - UI Setting
private extension TabBarViewController {
    func setupFrame() {
        var tabFrame = tabBar.frame
        tabFrame.size.height += 10
        tabFrame.origin.y = view.frame.size.height - tabFrame.size.height
        tabBar.frame = tabFrame
    }
    
    func configureTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = FlipMateColor.tabBarColor.color
        tabBar.layer.borderWidth = Constant.borderWidth
        tabBar.layer.borderColor = FlipMateColor.tabBarLayerColor.color?.cgColor
        tabBar.backgroundColor = FlipMateColor.tabBarColor.color
        tabBar.standardAppearance = tabBarAppearance
        view.addSubview(timerButton)
    }

    func setUpTimerButton() {
        let tabBarHeight = tabBar.frame.size.height
        timerButton.layer.cornerRadius = tabBarHeight / 2
        NSLayoutConstraint.activate([
            timerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerButton.widthAnchor.constraint(equalToConstant: tabBarHeight),
            timerButton.heightAnchor.constraint(equalToConstant: tabBarHeight),
            timerButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight * 1.5)
        ])
    }
}

// MARK: - objc function
private extension TabBarViewController {
    @objc private func timerButtonAction(sender: UIButton) {
        selectedIndex = 1
    }
}
