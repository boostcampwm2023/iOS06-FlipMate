//
//  FriendSearchResultView.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/28.
//

import UIKit

final class FriendSearchResultView: UIView, FreindAddResultViewProtocol {
    // MARK: - Costants
    private enum Constant {
        static let height: CGFloat = 250
        static let cornerRadius: CGFloat = 5
    }
    
    private enum ProfileImageConstant {
        static let cornerRadius: CGFloat = 50
        static let top: CGFloat = 30
        static let width: CGFloat = 100
        static let height: CGFloat = 100
    }
    
    private enum NickNameLabelConstant {
        static let name = "임현규"
        static let top: CGFloat = 15
    }
    
    private enum FlowButtonConstant {
        static let title = "친구추가"
        static let top: CGFloat = 15
        static let width: CGFloat = 90
        static let cornerRadius: CGFloat = 10
    }
    
    // MARK: - UI Components
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = FlipMateColor.gray2.color
        imageView.layer.cornerRadius = ProfileImageConstant.cornerRadius
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = NickNameLabelConstant.name
        label.textColor = .label
        return label
    }()
    
    private lazy var flowButton: UIButton = {
        let button = UIButton()
        button.setTitle(FlowButtonConstant.title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = FlipMateColor.darkBlue.color
        button.layer.cornerRadius = FlowButtonConstant.cornerRadius
        return button
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
}

// MARK: - Private Methods
private extension FriendSearchResultView {
    // MARK: - Configure UI
    func configureUI() {
        backgroundColor = FlipMateColor.gray3.color
        layer.cornerRadius = Constant.cornerRadius

        [profileImageView, nickNameLabel, flowButton].forEach {
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
            
            flowButton.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: FlowButtonConstant.top),
            flowButton.widthAnchor.constraint(equalToConstant: FlowButtonConstant.width),
            flowButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}


@available(iOS 17.0, *)
#Preview {
    FriendAddViewController()
}
