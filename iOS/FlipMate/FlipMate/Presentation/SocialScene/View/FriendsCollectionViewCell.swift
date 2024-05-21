//
//  FriendsCollectionViewCell.swift
//  FlipMate
//
//  Created by 권승용 on 11/29/23.
//

import UIKit

import Domain
import DesignSystem
import Core

final class FriendsCollectionViewCell: UICollectionViewCell {
    static let identifier = "FriendsCollectionViewCell"
    // MAKR: UI Components
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .profileImage
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(x: 0, y: 0, width: 90, height: 90)
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.red.cgColor
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
    
    private lazy var currentLearningTimeLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.textColor = .green
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("이 뷰는 스토리보드에서 사용할 수 없습니다")
    }
    
    // MARK: - Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        FMLogger.appLifeCycle.log("prepare for reuse")
        initUI()
    }
    
    private func initUI() {
        currentLearningTimeLabel.text = nil
        profileImageView.image = nil
        profileImageView.layer.borderColor = UIColor.red.cgColor
    }
    
    private func configureUI() {
        let subViews = [
            profileImageView,
            userNameLabel,
            learningTimeLabel,
            currentLearningTimeLabel
        ]
        
        subViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 90),
            profileImageView.heightAnchor.constraint(equalToConstant: 90),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            userNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            learningTimeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            learningTimeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            learningTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            learningTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            currentLearningTimeLabel.topAnchor.constraint(equalTo: learningTimeLabel.bottomAnchor, constant: 5),
            currentLearningTimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configure(friend: Friend) {
        // TODO: - 이미지 캐싱
        profileImageView.setImage(url: friend.profileImageURL)
        userNameLabel.text = friend.nickName
        learningTimeLabel.text = friend.totalTime.secondsToStringTime()
        profileImageView.layer.borderColor = friend.isStuding ? UIColor.green.cgColor : UIColor.red.cgColor
    }
    
    func updateLearningTime(_ currentLeaningTime: Int) {
        profileImageView.layer.borderColor = UIColor.green.cgColor
        currentLearningTimeLabel.text = "+ " + currentLeaningTime.secondsToStringTime()
    }
    
    func stopLearningTime(_ totalTime: Int) {
        profileImageView.layer.borderColor = UIColor.red.cgColor
        learningTimeLabel.text = totalTime.secondsToStringTime()
        currentLearningTimeLabel.text = nil
    }
}

private extension FriendsCollectionViewCell {
    enum Constant {
        static let defaultNickName = "닉네임"
        static let defaultTime = "00:00:00"
    }
}

@available(iOS 17, *)
#Preview {
    FriendsCollectionViewCell()
}
