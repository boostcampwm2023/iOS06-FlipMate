//
//  FriendAddViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/28.
//

import UIKit

final class FirendAddViewController: BaseViewController {
    // MARK: - Constant
    private enum NameTextFieldConstant {
        static let top: CGFloat = 20
        static let leading: CGFloat = 40
        static let height: CGFloat = 20
        static let placeholder = "친구 닉네임"
    }
    
    private enum NameCountLabelConstant {
        static let trailing: CGFloat = -40
        static let countTitle = "0/10"
    }
    
    private enum SeparatorLineConstant {
        static let top: CGFloat = 5
        static let leading: CGFloat = 40
        static let trailing: CGFloat = -40
        static let height: CGFloat = 1
    }
    
    // MARK: - UI Components
    private lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NameTextFieldConstant.placeholder
        return textField
    }()
    
    private lazy var nickNameCountLabel: UILabel = {
        let label = UILabel()
        label.text = NameCountLabelConstant.countTitle
        label.textColor = FlipMateColor.gray5.color
        return label
    }()
    
    private let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = FlipMateColor.gray5.color
        return view
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configure UI
    override func configureUI() {
        [nickNameTextField, nickNameCountLabel, separatorLineView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nickNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: NameTextFieldConstant.top),
            nickNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: NameTextFieldConstant.leading),
            nickNameTextField.trailingAnchor.constraint(equalTo: nickNameCountLabel.leadingAnchor),
            nickNameTextField.heightAnchor.constraint(equalToConstant: NameTextFieldConstant.height),
            
            nickNameCountLabel.centerYAnchor.constraint(equalTo: nickNameTextField.centerYAnchor),
            nickNameCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: NameCountLabelConstant.trailing),
            
            separatorLineView.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: SeparatorLineConstant.top),
            separatorLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SeparatorLineConstant.leading),
            separatorLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: SeparatorLineConstant.trailing),
            separatorLineView.heightAnchor.constraint(equalToConstant: SeparatorLineConstant.height)
        ])
        
    }
}

@available(iOS 17.0, *)
#Preview {
    FirendAddViewController()
}
