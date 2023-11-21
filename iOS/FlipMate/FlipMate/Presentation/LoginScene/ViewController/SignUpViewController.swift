//
//  SignUpViewController.swift
//  FlipMate
//
//  Created by 권승용 on 11/20/23.
//

import UIKit

final class SignUpViewController: BaseViewController {
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        let cameraView = UIImageView()
        imageView.image = UIImage(systemName: Constant.profileImageName)
        imageView.tintColor = FlipMateColor.darkBlue.color
        cameraView.image = UIImage(systemName: Constant.cameraImageName)
        cameraView.tintColor = FlipMateColor.gray1.color
        cameraView.backgroundColor = FlipMateColor.gray3.color
        cameraView.clipsToBounds = true
        cameraView.layer.cornerRadius = cameraView.bounds.height / 2
        imageView.addSubview(cameraView)
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            cameraView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0)
        ])
        return imageView
    }()
    
    private lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = FlipMateFont.mediumRegular.font
        textField.placeholder = Constant.nickNameTextFieldPlaceHolderText
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            var titleContainer = AttributeContainer()
            titleContainer.font = FlipMateFont.mediumBold.font
            configuration.baseBackgroundColor = FlipMateColor.darkBlue.color
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32)
            configuration.attributedTitle = AttributedString("회원가입", attributes: titleContainer)
            button.configuration = configuration
        } else {
            // iOS 14 지원
            button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
            button.setTitle("회원가입", for: .normal)
            button.titleLabel?.font = FlipMateFont.mediumBold.font
            button.backgroundColor = FlipMateColor.darkBlue.color
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        let underLine = UIView()
        underLine.frame = CGRect(x: 0, y: Double(nickNameTextField.frame.height) + 2, width: Double(nickNameTextField.frame.width), height: 1.5)
        underLine.backgroundColor = FlipMateColor.gray1.color
        self.nickNameTextField.addSubview(underLine)
    }
    
    override func configureUI() {
        self.title = "회원가입"
        
        let subViews = [
            profileImage,
            nickNameTextField,
            signUpButton
        ]
        
        subViews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            
            nickNameTextField.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
            nickNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nickNameTextField.widthAnchor.constraint(equalToConstant: 220),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            signUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
}

private extension SignUpViewController {
    enum Constant {
        static let profileImageName = "person.crop.circle.fill"
        static let cameraImageName = "camera.fill"
        static let nickNameTextFieldPlaceHolderText = "닉네임을 입력해 주세요"
    }
}

@available(iOS 17, *)
#Preview {
    SignUpViewController()
}
