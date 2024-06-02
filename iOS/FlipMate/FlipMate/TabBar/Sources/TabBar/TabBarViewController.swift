//
//  TabBarViewController.swift
//
//
//  Created by 권승용 on 6/2/24.
//

import UIKit
import DesignSystem
import Core

public protocol TimeZoneDelegate: AnyObject {
    func didChangeTimeZone()
}

public final class TabBarViewController: UITabBarController {
    
    // MARK: - Constant
    private enum Constant {
        static let timerImageName = "timer"
        static let borderWidth: CGFloat = 1.0
        static let timerImageSize: CGFloat = 40
        static let timeZone = NSLocalizedString("timeZone", comment: "")
        static let timeZoneMessage = NSLocalizedString("timeZoneMessage", comment: "")
        static let yes = NSLocalizedString("yes", comment: "")
    }
    
    // MARK: - Properties
    public weak var timeZoneDelegate: TimeZoneDelegate?
    
    // MARK: - UI Components
    lazy var timerButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = Constant.borderWidth
        button.backgroundColor = FlipMateColor.tabBarColor.color
        button.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        button.addTarget(self, action: #selector(timerButtonAction(sender:)), for: .touchUpInside)
        button.setShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.adjustsImageWhenHighlighted = false
        button.setImage(
            UIImage(
                systemName: Constant.timerImageName,
                withConfiguration: UIImage.SymbolConfiguration(
                    font: .systemFont(
                        ofSize: Constant.timerImageSize)))?.withRenderingMode(.alwaysTemplate),
            for: .normal)
        button.imageView?.tintColor = FlipMateColor.tabBarIconSelected.color
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureTimeZoneNotification()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrame()
        setUpTimerButton()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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
    
    func configureTimeZoneNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeTimeZone),
            name: NSNotification.Name.NSSystemTimeZoneDidChange,
            object: nil)
    }
}

// MARK: - objc function
private extension TabBarViewController {
    @objc private func timerButtonAction(sender: UIButton) {
        selectedIndex = 1
        timerButton.imageView?.tintColor = FlipMateColor.tabBarIconSelected.color
        FeedbackManager.shared.startTabBarItemTapFeedback()
    }
    
    @objc func didChangeTimeZone() {
        // MARK: - 타임존 대응
        FMLogger.device.log("타임존이 바뀌었습니다")
        showAlert()
    }
    
    func showAlert() {
        let alertController = UIAlertController(
            title: Constant.timeZone,
            message: Constant.timeZoneMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constant.yes, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.timeZoneDelegate?.didChangeTimeZone()
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

