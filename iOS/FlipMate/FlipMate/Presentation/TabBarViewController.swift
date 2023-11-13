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
        configureTimerButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 94
        tabFrame.origin.y = self.view.frame.size.height - 94
        self.tabBar.frame = tabFrame
    }
}

extension TabBarViewController {
    func setUpUI() {
        let timerViewController = TimerViewController()
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
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
    }

    func configureTimerButton() {
        let timerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 95, height: 95))
        var timerButtonFrame = timerButton.frame
        timerButtonFrame.origin.y = view.bounds.height - timerButtonFrame.height - 35
        timerButtonFrame.origin.x = view.bounds.width / 2 - timerButtonFrame.size.width / 2
        timerButton.frame = timerButtonFrame

        timerButton.backgroundColor = .white
        timerButton.layer.cornerRadius = timerButtonFrame.height / 2
        timerButton.layer.borderWidth = 0.5
        timerButton.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(timerButton)

        timerButton.setImage(UIImage(systemName: "timer",
                                     withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40))),
                                     for: .normal)
        timerButton.addTarget(self, action: #selector(timerButtonAction(sender:)), for: .touchUpInside)

        timerButton.tintColor = .darkGray
        view.layoutIfNeeded()
    }

    @objc private func timerButtonAction(sender: UIButton) {
        selectedIndex = 1
    }
}
