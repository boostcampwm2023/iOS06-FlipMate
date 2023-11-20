//
//  TabBarViewController.swift
//  FlipMate
//
//  Created by 신민규 on 11/13/23.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        configureTabBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrame()
        configureTimerButton()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.tabBar.layer.backgroundColor = FlipMateColor.tabBarColor.color?.cgColor
        self.tabBar.layer.borderColor = FlipMateColor.tabBarLayerColor.color?.cgColor
    }
}

// MARK: - UI Setting
private extension TabBarViewController {
    func setUpUI() {
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

        self.selectedIndex = 1
    }

    func setupFrame() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height += 10
        tabFrame.origin.y = self.view.frame.size.height - tabFrame.size.height
        self.tabBar.frame = tabFrame
    }
    
    func configureTabBar() {
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = FlipMateColor.tabBarLayerColor.color?.cgColor
        self.tabBar.layer.backgroundColor = FlipMateColor.tabBarColor.color?.cgColor
    }

    func configureTimerButton() {
        let timerButton = UIButton(frame: CGRect(x: 0, y: 0,
                                                 width: self.tabBar.frame.size.height * 0.5 + 45,
                                                 height: self.tabBar.frame.size.height * 0.5 + 45))
        var timerButtonFrame = timerButton.frame
        timerButtonFrame.origin.y = view.bounds.height - timerButtonFrame.height - self.tabBar.frame.size.height / 2 + 10
        timerButtonFrame.origin.x = view.bounds.width / 2 - timerButtonFrame.size.width / 2
        timerButton.frame = timerButtonFrame

        timerButton.backgroundColor = FlipMateColor.tabBarColor.color
        timerButton.layer.cornerRadius = timerButtonFrame.height / 2
        timerButton.layer.borderWidth = 0.5
        timerButton.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        timerButton.tintColor = FlipMateColor.gray3.color
        timerButton.setShadow()
        view.addSubview(timerButton)

        timerButton.setImage(UIImage(systemName: "timer",
                                     withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40))),
                                     for: .normal)
        timerButton.addTarget(self, action: #selector(timerButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }
}

// MARK: - objc function
private extension TabBarViewController {
    @objc private func timerButtonAction(sender: UIButton) {
        selectedIndex = 1
    }
}
