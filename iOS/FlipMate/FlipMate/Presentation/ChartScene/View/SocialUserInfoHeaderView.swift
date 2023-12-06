//
//  SocialUserInfoHeaderView.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/07.
//

import UIKit

final class SocialUserInfoHeaderView: UICollectionReusableView {
      
    // MARK: - Constant
    private enum Constant {
        static let defaultNickName = "닉네임"
        static let defaultTime = "00:00:00"
    }
    
    private enum ProfileImageViewConstant {
        static var width: CGFloat = 90
        static var height: CGFloat = 90
        static var top: CGFloat = 32
    }
    
    private enum UserNameLabelConstant {
        static var bottom: CGFloat = 8
        static var title = "닉네임"
    }
    
    private enum LearningTimeLabelConstant {
        static var bottom: CGFloat = 8
        static var title = "00:00:00"
    }
    
    private enum DividerConstant {
        static var bottom: CGFloat = 24
        static var height: CGFloat = 1
    }
    
    // MARK: UI Components
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .defaultProfile)
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(x: 0, y: 0, width: ProfileImageViewConstant.width, height: ProfileImageViewConstant.height)
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.text = Constant.defaultNickName
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var learningTimeLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.text = Constant.defaultTime
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .gray
        return divider
    }()
        
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    func update(nickname: String) {
        userNameLabel.text = nickname
    }
    
    func update(profileImageURL: String) {
        profileImageView.setImage(url: profileImageURL)
    }
    
    func update(learningTime: Int) {
        learningTimeLabel.text = learningTime.secondsToStringTime()
    }
}

// MARK: - UI Setting
private extension SocialUserInfoHeaderView {
    func configureUI() {
        [ profileImageView, userNameLabel, learningTimeLabel, divider ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: ProfileImageViewConstant.top),
            profileImageView.widthAnchor.constraint(equalToConstant: ProfileImageViewConstant.width),
            profileImageView.heightAnchor.constraint(equalToConstant: ProfileImageViewConstant.height),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: UserNameLabelConstant.bottom),
            userNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            learningTimeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: LearningTimeLabelConstant.bottom),
            learningTimeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            learningTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            learningTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            divider.topAnchor.constraint(equalTo: learningTimeLabel.bottomAnchor, constant: DividerConstant.bottom),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: DividerConstant.height)
        ])
    }
}
