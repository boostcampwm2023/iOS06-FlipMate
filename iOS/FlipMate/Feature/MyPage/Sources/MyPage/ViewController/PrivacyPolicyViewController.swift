//
//  PrivatePolicyViewController.swift
//
//
//  Created by 권승용 on 6/3/24.
//

import UIKit
import DesignSystem

final class PrivacyPolicyViewController: BaseViewController {
    enum Constant {
        static let privatePolicyLabel = NSLocalizedString("privacyPolicyLabel", comment: "")
        static let privacyPolicy = NSLocalizedString("privacyPolicy", comment: "")
    }
    // MARK: - View Properties
    private let scrollview: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.indicatorStyle = .default
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = FlipMateFont.smallRegular.font
        label.textColor = .label
        label.text = Constant.privatePolicyLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func configureUI() {
        self.navigationItem.title = Constant.privacyPolicy
        
        self.view.addSubview(scrollview)
        scrollview.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            scrollview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            scrollview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            scrollview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            scrollview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor, constant: -10),
            contentLabel.widthAnchor.constraint(equalTo: scrollview.widthAnchor)
        ])
    }
}
