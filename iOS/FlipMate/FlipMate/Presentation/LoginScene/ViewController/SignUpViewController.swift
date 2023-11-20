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
    
    override func configureUI() {
        self.title = "회원가입"
        
        let subViews = [
            profileImage,
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
