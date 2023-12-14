//
//  FriendSearchResultView.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/28.
//

import UIKit
import Combine

final class FriendSearchResultView: UIView, FreindAddResultViewProtocol {
    // MARK: - Costants
    private enum Constant {
        static let height: CGFloat = 250
        static let cornerRadius: CGFloat = 5
        static let alreadyFriend = NSLocalizedString("alreadyFriend", comment: "")
        static let myself = NSLocalizedString("myself", comment: "")
    }
    
    private enum ProfileImageConstant {
        static let cornerRadius: CGFloat = 50
        static let top: CGFloat = 30
        static let width: CGFloat = 100
        static let height: CGFloat = 100
    }
    
    private enum NickNameLabelConstant {
        static let top: CGFloat = 15
    }
    
    private enum FollowButtonConstant {
        static let title = NSLocalizedString("follow", comment: "")
        static let top: CGFloat = 15
        static let width: CGFloat = 90
        static let cornerRadius: CGFloat = 10
    }
    
    // MARK: - Properties
    private var tapSubject = PassthroughSubject<Void, Never>()

    // MARK: - UI Components
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = FlipMateColor.gray2.color
        imageView.layer.cornerRadius = ProfileImageConstant.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle(FollowButtonConstant.title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = FlipMateColor.darkBlue.color
        button.layer.cornerRadius = FollowButtonConstant.cornerRadius
        button.addTarget(self, action: #selector(followButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var infomationLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.smallRegular.font
        label.textColor = .label
        return label
    }()
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func height() -> CGFloat {
        return Constant.height
    }
    
    func updateUI(friendSearchItem: FreindSeacrhItem) {
        nickNameLabel.text = friendSearchItem.nickname
        profileImageView.setImage(url: friendSearchItem.iamgeURL)
        
        switch friendSearchItem.status {
        case .alreayFriend:
            infomationLabel.text = Constant.alreadyFriend
            setfollowButtonHidden(isHidden: true)
        case .myself:
            infomationLabel.text = Constant.myself
            setfollowButtonHidden(isHidden: true)
        default:
            setfollowButtonHidden(isHidden: false)
        }
    }
    
    func tapPublisher() -> AnyPublisher<Void, Never> {
        return tapSubject.eraseToAnyPublisher()
    }
}

// MARK: - Private Methods
private extension FriendSearchResultView {
    // MARK: - Configure UI
    func configureUI() {
        backgroundColor = FlipMateColor.gray3.color
        layer.cornerRadius = Constant.cornerRadius

        [profileImageView, nickNameLabel, followButton, infomationLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: ProfileImageConstant.top),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: ProfileImageConstant.width),
            profileImageView.heightAnchor.constraint(equalToConstant: ProfileImageConstant.height),
            
            nickNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: NickNameLabelConstant.top),
            nickNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            followButton.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: FollowButtonConstant.top),
            followButton.widthAnchor.constraint(equalToConstant: FollowButtonConstant.width),
            followButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            infomationLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: FollowButtonConstant.top),
            infomationLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setfollowButtonHidden(isHidden: Bool) {
        followButton.isHidden = isHidden
        infomationLabel.isHidden = !isHidden
    }
}

// MARK: - Objc func
private extension FriendSearchResultView {
    @objc func followButtonDidTapped() {
        tapSubject.send()
    }
}
