//
//  ProfileSettingsViewController.swift
//  FlipMate
//
//  Created by 권승용 on 12/5/23.
//

import UIKit
import Combine
import PhotosUI

final class ProfileSettingsViewController: BaseViewController {
    // MARK: - View Properties
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .defaultProfile)
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(
            x: profileImageConstant.x,
            y: profileImageConstant.y,
            width: profileImageConstant.width,
            height: profileImageConstant.heigth)
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
        imageView.layoutMargins = .init(
            top: cameraButtonConstant.topMargin,
            left: cameraButtonConstant.leftMargin,
            bottom: cameraButtonConstant.bottomMargin,
            right: cameraButtonConstant.rightMargin)
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(
            x: cameraButtonConstant.x,
            y: cameraButtonConstant.y,
            width: cameraButtonConstant.width,
            height: cameraButtonConstant.height)
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        return imageView
    }()
    
    private lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = FlipMateFont.mediumRegular.font
        textField.placeholder = Constant.nickNameTextFieldPlaceHolderText
        textField.delegate = self
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
            x: textFieldUnderlineConstant.x,
            y: Double(nickNameTextField.frame.height) + 2,
            width: Double(nickNameTextField.frame.width),
            height: textFieldUnderlineConstant.height)
        underline.backgroundColor = FlipMateColor.gray1.color
        return underline
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(
            top: doneButtonConstant.topInset,
            left: doneButtonConstant.leadingInset,
            bottom: doneButtonConstant.bottomInset,
            right: doneButtonConstant.trailingInset)
        button.setTitle(doneButtonConstant.title, for: .normal)
        button.titleLabel?.font = FlipMateFont.mediumBold.font
        button.backgroundColor = FlipMateColor.darkBlue.color
        button.clipsToBounds = true
        button.layer.cornerRadius = doneButtonConstant.cornerRaidus
        button.isEnabled = false
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: ProfileSettingsViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentNicknameState: NickNameValidationState?
    
    init(viewModel: ProfileSettingsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewReady()
    }
    
    override func viewDidLayoutSubviews() {
        drawTextFieldUnderline()
    }
    
    // MARK: - Configure UI
    override func configureUI() {
        self.title = Constant.title
        
        let subViews = [
            profileImageView,
            cameraButton,
            nickNameTextField,
            nickNameValidationStateLabel,
            doneButton
        ]
        
        subViews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: profileImageConstant.top),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageConstant.width),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageConstant.heigth),
            
            cameraButton.widthAnchor.constraint(equalToConstant: cameraButtonConstant.width),
            cameraButton.heightAnchor.constraint(equalToConstant: cameraButtonConstant.height),
            cameraButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            
            nickNameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: nicknameTextFieldConstant.top),
            nickNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nickNameTextField.widthAnchor.constraint(equalToConstant: nicknameTextFieldConstant.width),
            
            nickNameValidationStateLabel.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: nickNameValidationStateLabelConstant.bottom),
            nickNameValidationStateLabel.leadingAnchor.constraint(equalTo: nickNameTextField.leadingAnchor),
            nickNameValidationStateLabel.trailingAnchor.constraint(equalTo: nickNameTextField.trailingAnchor),
            
            doneButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: doneButtonConstant.top),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: doneButtonConstant.leading),
            doneButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: doneButtonConstant.trailing)
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
        bindNickNameRelatedPublishers()
        bindProfileImageRelatedPublishers()
        
        viewModel.isSignUpCompletedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.doneButton.isEnabled = true
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                FMLogger.general.error("SignUpViewModel에서 에러: \(error)")
                self?.doneButton.isEnabled = false
            }
            .store(in: &cancellables)
    }
    
    private func bindNickNameRelatedPublishers() {
        viewModel.nicknamePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self = self else { return }
                self.nickNameTextField.text = name
            }
            .store(in: &cancellables)
        
        viewModel.isValidNickNamePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                FMLogger.general.log("닉네임 유효성 상태 : \(state.message)")
                self.configureNickNameTextField(state)
            }
            .store(in: &cancellables)
    }
    
    private func bindProfileImageRelatedPublishers() {
        viewModel.imageURLPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageURL in
                guard let self = self else { return }
                self.profileImageView.setImage(url: imageURL)
            }
            .store(in: &cancellables)
        
        viewModel.isProfileImageChangedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if self?.currentNicknameState == nil || self?.currentNicknameState == .valid {
                    DispatchQueue.main.async {
                        self?.doneButton.isEnabled = true
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.imageNotSafePublisher
            .sink { [weak self] in
                let alert = UIAlertController(title: "이 이미지는 사용할 수 없습니다.", message: "이미지 유해성이 확인되었습니다. 다른 이미지를 선택해 주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureNickNameTextField(_ state: NickNameValidationState) {
        self.currentNicknameState = state
        DispatchQueue.main.async {
            switch state {
            case .valid:
                self.nickNameValidationStateLabel.text = state.message
                self.nickNameValidationStateLabel.textColor = FlipMateColor.approveGreen.color
                self.doneButton.isEnabled = true
            case .lengthViolation:
                self.nickNameValidationStateLabel.text = state.message
                self.nickNameValidationStateLabel.textColor = FlipMateColor.warningRed.color
                self.doneButton.isEnabled = false
            case .emptyViolation:
                self.nickNameValidationStateLabel.text = state.message
                self.nickNameValidationStateLabel.textColor = FlipMateColor.warningRed.color
                self.doneButton.isEnabled = false
            case .duplicated:
                self.nickNameValidationStateLabel.text = state.message
                self.nickNameValidationStateLabel.textColor = FlipMateColor.warningRed.color
                self.doneButton.isEnabled = false
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension ProfileSettingsViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let nickname = textField.text else { return }
        guard nickname.count <= Constant.maxLength else {
            textField.deleteBackward()
            textField.resignFirstResponder()
            return
        }
        viewModel.nickNameChanged(nickname)
    }
}

// MARK: - Selector Methods
private extension ProfileSettingsViewController {
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
        doneButton.isEnabled = false
        let userName = nickNameTextField.text ?? ""
        guard let imageData = profileImageView.image?.jpegData(compressionQuality: 1) else {
            FMLogger.general.error("no profile image selected")
            return
        }
        viewModel.signUpButtonTapped(userName: userName, profileImageData: imageData)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ProfileSettingsViewController: PHPickerViewControllerDelegate {
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
                self.viewModel.profileImageChanged()
            }
        }
    }
}

// MARK: - Constants
private extension ProfileSettingsViewController {
    enum Constant {
        static let title = "프로필 수정"
        static let cameraImageName = "camera.fill"
        static let nickNameTextFieldPlaceHolderText = "닉네임을 입력해 주세요"
        static let maxLength = 10
    }
    
    enum profileImageConstant {
        static let x: CGFloat = 0
        static let y: CGFloat = 0
        static let width: CGFloat = 100
        static let heigth: CGFloat = 100
        static let top: CGFloat = 64
    }
    
    enum cameraButtonConstant {
        static let topMargin: CGFloat = 8
        static let leftMargin: CGFloat = 16
        static let bottomMargin: CGFloat = 8
        static let rightMargin: CGFloat = 16
        
        static let x: CGFloat = 0
        static let y: CGFloat = 0
        static let width: CGFloat = 33
        static let height: CGFloat = 33
    }
    
    enum nicknameTextFieldConstant {
        static let top: CGFloat = 16
        static let width: CGFloat = 220
    }
    
    enum nickNameValidationStateLabelConstant {
        static let bottom: CGFloat = 16
    }
    
    enum textFieldUnderlineConstant {
        static let x: CGFloat = 0
        static let height: CGFloat = 1.5
    }
    
    enum doneButtonConstant {
        static let topInset: CGFloat = 16
        static let leadingInset: CGFloat = 32
        static let bottomInset: CGFloat = 16
        static let trailingInset: CGFloat = 32
        static let title = "완료"
        static let cornerRaidus: CGFloat = 15
        
        static let top: CGFloat = -64
        static let leading: CGFloat = 32
        static let trailing: CGFloat = -32
    }
}
