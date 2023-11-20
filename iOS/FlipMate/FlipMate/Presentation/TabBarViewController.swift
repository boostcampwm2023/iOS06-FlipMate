//
//  TabBarViewController.swift
//  FlipMate
//
//  Created by 신민규 on 11/13/23.
//

import UIKit

final class TabBarViewController: UITabBarController {

    private lazy var timerButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 0.5
        button.backgroundColor = FlipMateColor.tabBarColor.color
        button.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        button.tintColor = FlipMateColor.gray3.color
        button.addTarget(self, action: #selector(timerButtonAction(sender:)), for: .touchUpInside)
        button.setShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "timer",
                                     withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40))),
                                     for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
    func configureUI() {
        let timerViewController = TimerViewController(timerViewModel: TimerViewModel(timerUseCase: DefaultTimerUseCase()), feedbackManager: FeedbackManager())
        let socialViewController = SocialViewController()
        let chartViewController = ChartViewController()

        socialViewController.tabBarItem.image = UIImage(systemName: "person.3")
        socialViewController.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")

        chartViewController.tabBarItem.image = UIImage(systemName: "chart.bar")
        chartViewController.tabBarItem.selectedImage = UIImage(systemName: "chart.bar.fill")

        let navigationTimer = UINavigationController(rootViewController: timerViewController)
        let navigationSocial = UINavigationController(rootViewController: socialViewController)
        let navigationChart = UINavigationController(rootViewController: chartViewController)

        setViewControllers([navigationSocial, navigationTimer, navigationChart], animated: false)

        selectedIndex = 1
    }

    func setupFrame() {
        var tabFrame = tabBar.frame
        tabFrame.size.height += 10
        tabFrame.origin.y = view.frame.size.height - tabFrame.size.height
        tabBar.frame = tabFrame
    }
    
    func configureTabBar() {
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = FlipMateColor.tabBarLayerColor.color?.cgColor
        tabBar.layer.backgroundColor = FlipMateColor.tabBarColor.color?.cgColor
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
