//
//  SocialDetailViewController.swift
//  FlipMate
//
//  Created by 신민규 on 11/28/23.
//

import UIKit

final class SocialDetailViewController: BaseViewController {
    private enum Constant {
        static let dailyStudyLog = "오늘 학습 시간"
        static let weeklyStudyLog = "주간 학습 시간"
        static let monthlyStudyLog = "월간 학습 시간"
        static let unfollow = "팔로우 취소"
    }
    
    // MARK: - UI Components
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = FlipMateColor.darkBlue.color
        
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "닉네임"
        label.font = FlipMateFont.mediumBold.font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var unfollowButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.unfollow, for: .normal)
        button.backgroundColor = FlipMateColor.darkBlue.color
        button.titleLabel?.font = FlipMateFont.mediumBold.font
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        // button.addTarget(self, action: #selector(unfollowButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .gray
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        return divider
    }()
    
    private lazy var dailyStudyLogLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumRegular.font
        label.textColor = .label
        label.textAlignment = .center
        label.text = Constant.dailyStudyLog
        
        return label
    }()
    
    private lazy var weeklyStudyLogLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumRegular.font
        label.textColor = .label
        label.textAlignment = .center
        label.text = Constant.weeklyStudyLog
        
        return label
    }()
    
    private lazy var monthlyStudyLogLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumRegular.font
        label.textColor = .label
        label.textAlignment = .center
        label.text = Constant.monthlyStudyLog
        
        return label
    }()
    
    private lazy var studyLogStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        
        return stackView
    }()
    
    private lazy var dailyStudyTimeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumBold.font
        label.textColor = FlipMateColor.gray2.color
        label.textAlignment = .right
        label.text = "9H 12m"
        
        return label
    }()
    
    private lazy var weeklyStudyTimeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumRegular.font
        label.textColor = FlipMateColor.gray2.color
        label.textAlignment = .right
        label.text = "45H 36m"
        
        return label
    }()
    
    private lazy var monthlyStudyTimeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumRegular.font
        label.textColor = FlipMateColor.gray2.color
        label.textAlignment = .right
        label.text = "175H"
        
        return label
    }()
    
    private lazy var studyTimeStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        return stackView
    }()
    
    // MARK: - View Life Cycles
    override func configureUI() {
        setStudyLogStackView()
        setStudyTimeStackView()
        
        [profileImageView, nickNameLabel, unfollowButton, divider, studyLogStackView, studyTimeStackView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 36),
            profileImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            
            nickNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            nickNameLabel.widthAnchor.constraint(equalToConstant: 80),
            nickNameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            unfollowButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            unfollowButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            unfollowButton.widthAnchor.constraint(equalToConstant: 96),
            unfollowButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            studyLogStackView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 32),
            studyLogStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            studyLogStackView.heightAnchor.constraint(equalToConstant: 120),
            
            studyTimeStackView.topAnchor.constraint(equalTo: studyLogStackView.topAnchor),
            studyTimeStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            studyTimeStackView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

private extension SocialDetailViewController {
    func setStudyLogStackView() {
        [dailyStudyLogLabel, weeklyStudyLogLabel, monthlyStudyLogLabel].forEach {
            studyLogStackView.addArrangedSubview($0)
        }
    }
    
    func setStudyTimeStackView() {
        [dailyStudyTimeLabel, weeklyStudyTimeLabel, monthlyStudyTimeLabel].forEach {
            studyTimeStackView.addArrangedSubview($0)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    SocialDetailViewController()
}
