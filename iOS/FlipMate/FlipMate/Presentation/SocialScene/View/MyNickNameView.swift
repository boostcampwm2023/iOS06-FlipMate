//
//  MyNickNameView.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/28.
//

import UIKit

final class MyNickNameView: UIView, FreindAddResultViewProtocol {
    private enum Constant {
        static let nameTitle = "내 닉네임"
        static let nameContent = "사용자닉네임"
        static let height: CGFloat = 30
        static let leading: CGFloat = 10
        static let trailing: CGFloat = -10
        static let cornerRadius: CGFloat = 5
    }
    
    // MARK: - UI Components
    private let nickNameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.nameTitle
        label.textColor = .label
        return label
    }()
    
    private let nickNameContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = Constant.nameContent
        return label
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    func height() -> CGFloat {
        return Constant.height
    }
    
    func updateUI(nickname: String) {
        nickNameContentLabel.text = nickname
    }
}

// MARK: - Private Method
private extension MyNickNameView {
    // MARK: - Configure UI
    func configureUI() {
        backgroundColor = FlipMateColor.gray3.color
        layer.cornerRadius = Constant.cornerRadius
        
        [nickNameTitleLabel, nickNameContentLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nickNameTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nickNameTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.leading),
            
            nickNameContentLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nickNameContentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constant.trailing)
        ])
    }
}
