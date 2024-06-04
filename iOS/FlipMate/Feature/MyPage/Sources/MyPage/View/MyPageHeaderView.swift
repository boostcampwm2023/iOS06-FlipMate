//
//  MyPageHeaderView.swift
//
//
//  Created by 권승용 on 6/3/24.
//

import UIKit
import DesignSystem

final class MyPageHeaderView: UIView {
    // MARK: - View Properties
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .profileImage
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var userNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.textColor = .label
        return label
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = FlipMateColor.gray5.color
        return divider
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("no storyboard")
    }
    
    private func configureUI() {
        let subviews = [
            profileImageView,
            userNicknameLabel,
            divider
        ]
        
        subviews.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            userNicknameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            userNicknameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            divider.topAnchor.constraint(equalTo: userNicknameLabel.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    func configureProfileImage(_ url: String?) {
        self.profileImageView.setImage(url: url)
        
    }
    
    func configureNickname(_ name: String) {
        self.userNicknameLabel.text = name
    }
}
