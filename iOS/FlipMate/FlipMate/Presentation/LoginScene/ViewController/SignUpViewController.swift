//
//  SignUpViewController.swift
//  FlipMate
//
//  Created by 권승용 on 11/20/23.
//

import UIKit
import Combine
import PhotosUI

final class SignUpViewController: BaseViewController {
    
    // MARK: - View Properties
    /// 프로필 이미지 뷰
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .defaultProfile)
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(profileImageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    private lazy var cameraButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constant.cameraImageName)
        imageView.tintColor = FlipMateColor.gray1.color
        imageView.backgroundColor = FlipMateColor.gray3.color
        imageView.contentMode = .center
        imageView.layoutMargins = .init(top: 8, left: 16, bottom: 8, right: 16)
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(x: 0, y: 0, width: 33, height: 33)
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        return imageView
    }()
    
    private lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = FlipMateFont.mediumRegular.font
        textField.placeholder = Constant.nickNameTextFieldPlaceHolderText
        textField.addTarget(self, action: #selector(nickNameTextFieldChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var nickNameValidationStateLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.smallBold.font
        label.textColor = FlipMateColor.warningRed.color
        return label
    }()
    
    private lazy var textFieldUnderline: UIView = {
        let underline = UIView()
        underline.frame = CGRect(
            x: 0,
            y: Double(nickNameTextField.frame.height) + 2,
            width: Double(nickNameTextField.frame.width),
            height: 1.5)
        underline.backgroundColor = FlipMateColor.gray1.color
        return underline
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            var titleContainer = AttributeContainer()
            titleContainer.font = FlipMateFont.mediumBold.font
            configuration.baseBackgroundColor = FlipMateColor.darkBlue.color
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: 16,
                leading: 32,
                bottom: 16,
                trailing: 32)
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
        button.isEnabled = false
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: SignUpViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private var typingTimer: Timer?
    
    init(viewModel: SignUpViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Life Cycles
    override func viewDidLayoutSubviews() {
        drawTextFieldUnderline()
    }
    
    // MARK: - Configure UI
    override func configureUI() {
        self.title = "회원가입"
        
        let subViews = [
            profileImageView,
            cameraButton,
            nickNameTextField,
            nickNameValidationStateLabel,
            signUpButton
        ]
        
        subViews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            cameraButton.widthAnchor.constraint(equalToConstant: 33),
            cameraButton.heightAnchor.constraint(equalToConstant: 33),
            cameraButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            
            nickNameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nickNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nickNameTextField.widthAnchor.constraint(equalToConstant: 220),
            
            nickNameValidationStateLabel.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 16),
            nickNameValidationStateLabel.leadingAnchor.constraint(equalTo: nickNameTextField.leadingAnchor),
            nickNameValidationStateLabel.trailingAnchor.constraint(equalTo: nickNameTextField.trailingAnchor),
            
            signUpButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            signUpButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    func drawTextFieldUnderline() {
        self.nickNameTextField.addSubview(textFieldUnderline)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Viewmodel Binding
    override func bind() {
        viewModel.isValidNickNamePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                FMLogger.general.log("닉네임 유효성 상태 : \(state.message)")
                switch state {
                case .valid:
                    self?.nickNameValidationStateLabel.text = state.message
                    self?.nickNameValidationStateLabel.textColor = FlipMateColor.approveGreen.color
                    self?.signUpButton.isEnabled = true
                case .lengthViolation:
                    self?.nickNameValidationStateLabel.text = state.message
                    self?.nickNameValidationStateLabel.textColor = FlipMateColor.warningRed.color
                    self?.signUpButton.isEnabled = false
                case .emptyViolation:
                    self?.nickNameValidationStateLabel.text = state.message
                    self?.nickNameValidationStateLabel.textColor = FlipMateColor.warningRed.color
                    self?.signUpButton.isEnabled = false
                case .duplicated:
                    self?.nickNameValidationStateLabel.text = state.message
                    self?.nickNameValidationStateLabel.textColor = FlipMateColor.warningRed.color
                    self?.signUpButton.isEnabled = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.isSignUpCompletedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.signUpButton.isEnabled = true
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                FMLogger.general.error("SignUpViewModel에서 에러")
                self?.signUpButton.isEnabled = false
            }
            .store(in: &cancellables)
    }
}

// MARK: - Selector Methods
private extension SignUpViewController {
    @objc
    func nickNameTextFieldChanged(_ sender: UITextField) {
        signUpButton.isEnabled = false
        guard let text = sender.text else {
            FMLogger.user.log("닉네임 텍스트필드 내용 없음")
            return
        }
        
        if typingTimer != nil {
            typingTimer?.invalidate()
            typingTimer = nil
        }
        
        typingTimer = Timer.scheduledTimer(
            timeInterval: 2,
            target: self,
            selector: #selector(waitedTwoSeconds(_:)),
            userInfo: text,
            repeats: false)
    }
    
    @objc
    func waitedTwoSeconds(_ sender: Timer) {
        guard let text = sender.userInfo as? String else {
            return
        }
        viewModel.nickNameChanged(text)
    }
    
    // 이미지 픽커 처리
    @objc
    func profileImageViewTapped() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // 회원가입 처리
    @objc
    func signUpButtonTapped() {
        signUpButton.isEnabled = false
        let userName = nickNameTextField.text ?? ""
        guard let imageData = profileImageView.image?.jpegData(compressionQuality: 1) else {
            FMLogger.general.error("no profile image selected")
            return
        }
        viewModel.signUpButtonTapped(userName: userName, profileImageData: imageData)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension SignUpViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        // 유저가 이미지 선택하지 않음
        guard let itemProvider = results.first?.itemProvider else {
            FMLogger.general.log("empty result: 유저가 이미지 선택하지 않음")
            return
        }
        
        // 이미지 로드 실패
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
            FMLogger.general.error("ERROR: 이미지 로드 불가능")
            return
        }
        
        // 이미지 처리하기
        let previousImage = profileImageView.image
        itemProvider.loadObject(ofClass: UIImage.self) {[weak self] (image, error) in
            if error != nil {
                FMLogger.general.error("ERROR: 이미지 로드 중 에러 : \(error)")
                return
            }
            // 이미지 저장
            DispatchQueue.main.async {
                guard let self = self,
                      let image = image as? UIImage,
                      self.profileImageView.image == previousImage else {
                    FMLogger.general.error("ERROR: 이미지 저장 실패")
                    return
                }
                self.profileImageView.image = image
            }
        }
    }
}

// MARK: - Constants
private extension SignUpViewController {
    enum Constant {
        static let profileImageName = "person.crop.circle.fill"
        static let cameraImageName = "camera.fill"
        static let nickNameTextFieldPlaceHolderText = "닉네임을 입력해 주세요"
    }
}
