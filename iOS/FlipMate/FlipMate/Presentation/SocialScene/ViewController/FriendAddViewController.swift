//
//  FriendAddViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/28.
//

import UIKit

final class FriendAddViewController: BaseViewController {
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
    
    private enum containerViewConstant {
        static let top: CGFloat = 15
        static let leading: CGFloat = 40
        static let trailing: CGFloat = -40
    }

    // MARK: - UI Components
    private lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NameTextFieldConstant.placeholder
        textField.becomeFirstResponder()
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
    
    private let containerView = UIView()
    private let myNickNameView = MyNickNameView()
    private let noResultView = NoResultView()
    private let friendSearchResultView = FriendSearchResultView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateResultView(myNickNameView)
    }
    
    // MARK: - Configure UI
    override func configureUI() {
        [nickNameTextField, nickNameCountLabel, separatorLineView, containerView].forEach {
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
            separatorLineView.heightAnchor.constraint(equalToConstant: SeparatorLineConstant.height),
            
            containerView.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: containerViewConstant.top),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: containerViewConstant.leading),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: containerViewConstant.trailing),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Private Methods
private extension FriendAddViewController {
    func updateResultView(_ resultView: FreindAddResultViewProtocol) {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(resultView)
        resultView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: containerView.topAnchor),
            resultView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            resultView.heightAnchor.constraint(equalToConstant: resultView.height())
        ])
    }
}

@available(iOS 17.0, *)
#Preview {
    FriendAddViewController()
}
