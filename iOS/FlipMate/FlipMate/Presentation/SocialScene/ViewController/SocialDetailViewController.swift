//
//  SocialDetailViewController.swift
//  FlipMate
//
//  Created by 신민규 on 11/28/23.
//

import UIKit

final class SocialDetailViewController: BaseViewController {
    private enum Constant {
        static let userLogInStatus = "접속 중"
        static let userLogOutStatus = "21h 25m 전"
        static let dailyStudyLog = "오늘 학습 시간"
        static let weeklyStudyLog = "주간 학습 시간"
        static let monthlyStudyLog = "월간 학습 시간"
    }
    
    // MARK: - UI Components
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = FlipMateColor.gray1.color
        view.layer.opacity = 0.4
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var detailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        
        return view
    }()
    private lazy var closeImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "x.circle")
        imageView.tintColor = FlipMateColor.darkBlue.color
        
        return imageView
    }()
    
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
        label.font = FlipMateFont.largeBold.font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var userStatusLabel: UILabel = {
        let label = UILabel()
        
        label.text = Constant.userLogInStatus
        label.font = FlipMateFont.mediumRegular.font
        label.textColor = FlipMateColor.gray2.color
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        return stackView
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
        stackView.spacing = 12
        
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
        view.backgroundColor = .clear
        
        setUserInfoStackView()
        setStudyLogStackView()
        setStudyTimeStackView()
        
        [profileImageView, userInfoStackView, studyLogStackView, studyTimeStackView, closeImage].forEach {
            detailView.addSubview($0)
        }
        
        [backgroundView, detailView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            detailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            detailView.heightAnchor.constraint(equalToConstant: 360),
            
            closeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            closeImage.heightAnchor.constraint(equalToConstant: 72),
            closeImage.widthAnchor.constraint(equalToConstant: 72)
        ])
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 36),
            profileImageView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 72),
            profileImageView.heightAnchor.constraint(equalToConstant: 110),
            
            userInfoStackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            userInfoStackView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -60),
            userInfoStackView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            studyLogStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
            studyLogStackView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 40),
            studyLogStackView.heightAnchor.constraint(equalToConstant: 120),
            
            studyTimeStackView.topAnchor.constraint(equalTo: studyLogStackView.topAnchor),
            studyTimeStackView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -40),
            studyTimeStackView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

private extension SocialDetailViewController {
    func setUserInfoStackView() {
        [nickNameLabel, userStatusLabel].forEach {
            userInfoStackView.addArrangedSubview($0)
        }
    }
    
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
