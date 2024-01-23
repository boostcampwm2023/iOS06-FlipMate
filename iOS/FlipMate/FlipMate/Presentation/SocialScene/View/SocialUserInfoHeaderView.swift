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
        static let defaultNickName = NSLocalizedString("nickname", comment: "")
        static let following = NSLocalizedString("followingNumber", comment: "")
        static let follower = NSLocalizedString("followerNumber", comment: "")
        static let defaultTime = "00:00:00"
        static let defaultNumber = "0"
    }
    
    private enum ProfileImageViewConstant {
        static var width: CGFloat = 60
        static var height: CGFloat = 60
        static var top: CGFloat = 32
        static var leading: CGFloat = 20
        static var spacing: CGFloat = 5
    }
    
    private enum UserNameLabelConstant {
        static var bottom: CGFloat = 8
        static var title = Constant.defaultNickName
    }
    
    private enum LearningTimeLabelConstant {
        static var bottom: CGFloat = 8
        static var title = "00:00:00"
    }
    
    private enum FollowViewConstant {
        static var spacing: CGFloat = 10
        static var trailing: CGFloat = -20
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
    
    private lazy var userInfoStackView: UIStackView = {
        let view = UIStackView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.spacing = ProfileImageViewConstant.spacing
        
        return view
    }()
    
    private lazy var followInfoStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.spacing = FollowViewConstant.spacing
        
        return view
    }()
    
    lazy var followingStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.spacing = FollowViewConstant.spacing
        
        return view
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        
        label.font = FlipMateFont.mediumRegular.font
        label.text = Constant.following
        label.textColor = FlipMateColor.gray2.color
        
        return label
    }()
    
    private lazy var followingNumberLabel: UILabel = {
        let label = UILabel()
        
        label.font = FlipMateFont.mediumBold.font
        label.textColor = .label
        label.text = Constant.defaultNumber
        
        return label
    }()
    
    lazy var followerStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.spacing = FollowViewConstant.spacing
        
        return view
    }()
    
    private lazy var followerLabel: UILabel = {
        let label = UILabel()
        
        label.font = FlipMateFont.mediumRegular.font
        label.text = Constant.follower
        label.textColor = FlipMateColor.gray2.color
        
        return label
    }()
    
    private lazy var followerNumberLabel: UILabel = {
        let label = UILabel()
        
        label.font = FlipMateFont.mediumBold.font
        label.textColor = .label
        label.text = Constant.defaultNumber
        
        return label
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
        label.textColor = FlipMateColor.gray2.color
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
    
    func update(profileImageURL: String?) {
        profileImageView.setImage(url: profileImageURL)
    }
    
    func update(learningTime: Int) {
        learningTimeLabel.text = learningTime.secondsToStringTime()
    }
    
    func update(following: Int) {
        followingNumberLabel.text = "\(following)"
    }
    
    func update(follower: Int) {
        followerNumberLabel.text = "\(follower)"
    }
}

// MARK: - UI Setting
private extension SocialUserInfoHeaderView {
    func configureUI() {
        [ profileImageView, userInfoStackView, followInfoStackView, divider ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        [userNameLabel, learningTimeLabel].forEach {
            self.userInfoStackView.addArrangedSubview($0)
        }
        
        [followingStackView, followerStackView].forEach {
            self.followInfoStackView.addArrangedSubview($0)
        }
        
        [followingLabel, followingNumberLabel].forEach {
            self.followingStackView.addArrangedSubview($0)
        }
        
        [followerLabel, followerNumberLabel].forEach {
            self.followerStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: ProfileImageViewConstant.top),
            profileImageView.widthAnchor.constraint(equalToConstant: ProfileImageViewConstant.width),
            profileImageView.heightAnchor.constraint(equalToConstant: ProfileImageViewConstant.height),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ProfileImageViewConstant.leading),
            
            userInfoStackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            userInfoStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: ProfileImageViewConstant.leading),
            
            followInfoStackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            followInfoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: FollowViewConstant.trailing),
            
            divider.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: DividerConstant.bottom),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: DividerConstant.height)
        ])
    }
}
