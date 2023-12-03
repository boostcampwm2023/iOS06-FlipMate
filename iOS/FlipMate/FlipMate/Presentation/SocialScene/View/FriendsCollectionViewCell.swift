//
//  FriendsCollectionViewCell.swift
//  FlipMate
//
//  Created by 권승용 on 11/29/23.
//

import UIKit

final class FriendsCollectionViewCell: UICollectionViewCell {
    static let identifier = "FriendsCollectionViewCell"
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .defaultProfile)
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(x: 0, y: 0, width: 90, height: 90)
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 1
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("이 뷰는 스토리보드에서 사용할 수 없습니다")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        FMLogger.appLifeCycle.log("prepare for reuse")
    }
    
    private func configureUI() {
        let subViews = [
            profileImageView,
            userNameLabel,
            learningTimeLabel
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
            learningTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configure(friend: Friend) {
        // TODO: - 이미지 캐싱
        let image = UIImage(resource: .defaultProfile)
        profileImageView.image = image
        userNameLabel.text = friend.nickName
        learningTimeLabel.text = friend.totalTime?.secondsToStringTime()
        profileImageView.layer.borderColor = friend.isStuding ? UIColor.green.cgColor : UIColor.red.cgColor
        
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
