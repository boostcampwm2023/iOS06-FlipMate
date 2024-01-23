//
//  FollowTableViewCell.swift
//  FlipMate
//
//  Created by 신민규 on 1/16/24.
//

import UIKit

final class FollowTableViewCell: UITableViewCell {
    static let identifier = "FollowTableViewCell"
    
    private enum ComponentConstant {
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 12
    }
    
    private enum LayoutConstant {
        static let topAnchor: CGFloat = 8
        static let bottomAnchor: CGFloat = -8
        static let leadingAnchor: CGFloat = 12
        static let trailingAnchor: CGFloat = -12
        static let profileImageHeight: CGFloat = 50
        static let profileImageWidth: CGFloat = 50
        static let buttonWidth: CGFloat = 92
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = FlipMateColor.gray2.color
        imageView.layer.cornerRadius = LayoutConstant.profileImageWidth / 2
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.textColor = .label
        label.text = "라벨 입니다"
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
    
        button.backgroundColor = FlipMateColor.darkBlue.color
        button.titleLabel?.font = FlipMateFont.mediumBold.font
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        button.layer.borderWidth = ComponentConstant.borderWidth
        button.layer.cornerRadius = ComponentConstant.cornerRadius
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("don't use storyboard")
    }
    
    private func configureUI() {
        let subviews = [
            profileImageView, title, followButton
        ]
        
        subviews.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LayoutConstant.leadingAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: LayoutConstant.profileImageHeight),
            profileImageView.widthAnchor.constraint(equalToConstant: LayoutConstant.profileImageWidth),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: LayoutConstant.leadingAnchor),
            title.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            followButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: LayoutConstant.trailingAnchor),
            followButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            followButton.widthAnchor.constraint(equalToConstant: LayoutConstant.buttonWidth)
        ])
    }
    
    func configureCell(imageUrl: String, title: String, buttonTitle: String) {
        self.profileImageView.setImage(url: imageUrl)
        self.title.text = title
        self.followButton.setTitle(buttonTitle, for: .normal)
    }
}
