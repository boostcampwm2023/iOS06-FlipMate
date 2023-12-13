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
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .defaultProfile)
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(
            x: ProfileImageConstant.xPos,
            y: ProfileImageConstant.yPos,
            width: ProfileImageConstant.width,
            height: ProfileImageConstant.heigth)
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
            top: CameraButtonConstant.topMargin,
            left: CameraButtonConstant.leftMargin,
            bottom: CameraButtonConstant.bottomMargin,
            right: CameraButtonConstant.rightMargin)
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(
            x: CameraButtonConstant.xPos,
            y: CameraButtonConstant.yPos,
            width: CameraButtonConstant.width,
            height: CameraButtonConstant.height)
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
            x: TextFieldUnderlineConstant.xPos,
            y: Double(nickNameTextField.frame.height) + 2,
            width: Double(nickNameTextField.frame.width),
            height: TextFieldUnderlineConstant.height)
        underline.backgroundColor = FlipMateColor.gray1.color
        return underline
    }()
    
    private lazy var doneButton: DoneButton = {
        let button = DoneButton()
        button.contentEdgeInsets = UIEdgeInsets(
            top: DoneButtonConstant.topInset,
            left: DoneButtonConstant.leadingInset,
            bottom: DoneButtonConstant.bottomInset,
            right: DoneButtonConstant.trailingInset)
        button.setTitle(DoneButtonConstant.title, for: .normal)
        button.titleLabel?.font = FlipMateFont.mediumBold.font
        button.backgroundColor = FlipMateColor.darkBlue.color
        button.setBackgroundColor(FlipMateColor.darkBlue.color, for: .normal)
        button.setBackgroundColor(FlipMateColor.gray2.color, for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = DoneButtonConstant.cornerRaidus
        button.isEnabled = false
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: SignUpViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
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
            doneButton
        ]
        
        subViews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ProfileImageConstant.top),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: ProfileImageConstant.width),
            profileImageView.heightAnchor.constraint(equalToConstant: ProfileImageConstant.heigth),
            
            cameraButton.widthAnchor.constraint(equalToConstant: CameraButtonConstant.width),
            cameraButton.heightAnchor.constraint(equalToConstant: CameraButtonConstant.height),
            cameraButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            
            nickNameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: NicknameTextFieldConstant.top),
            nickNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nickNameTextField.widthAnchor.constraint(equalToConstant: NicknameTextFieldConstant.width),
            
            nickNameValidationStateLabel.topAnchor.constraint(
                equalTo: nickNameTextField.bottomAnchor,
                constant: NickNameValidationStateLabelConstant.bottom),
            nickNameValidationStateLabel.leadingAnchor.constraint(equalTo: nickNameTextField.leadingAnchor),
            nickNameValidationStateLabel.trailingAnchor.constraint(equalTo: nickNameTextField.trailingAnchor),
            
            doneButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: DoneButtonConstant.bottom),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: DoneButtonConstant.leading),
            doneButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: DoneButtonConstant.trailing)
        ])
        
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.topItem?.title = ""
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
            .sink { [weak self] state in
                FMLogger.general.log("닉네임 유효성 상태 : \(state.message)")
                DispatchQueue.main.async {
                    self?.configureNickNameTextField(state)
                }
            }
            .store(in: &cancellables)
        
        viewModel.isSignUpCompletedPublisher
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.doneButton.isEnabled = true
                }
            }
            .store(in: &cancellables)
        
        viewModel.imageNotSafePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showErrorAlert(title: Constant.imageNotSafeTitle, message: Constant.imageNotSafeMessage)
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.doneButton.isEnabled = false
                self?.showErrorAlert(title: Constant.errorOccurred, message: "\(error)")
                FMLogger.general.error("SignUpViewModel에서 에러: \(error)")
            }
            .store(in: &cancellables)
    }
    
    private func configureNickNameTextField(_ state: NickNameValidationState) {
        DispatchQueue.main.async {
            switch state {
            case .valid:
                self.approveNickName()
            case .lengthViolation:
                self.invalidNickName(state)
            case .emptyViolation:
                self.invalidNickName(state)
            case .duplicated:
                self.invalidNickName(state)
            case .emojiContained:
                self.invalidNickName(state)
            }
        }
    }
    
    private func approveNickName() {
        self.nickNameValidationStateLabel.text = NickNameValidationState.valid.message
        self.nickNameValidationStateLabel.textColor = FlipMateColor.approveGreen.color
        self.doneButton.isEnabled = true
    }
    
    private func invalidNickName(_ state: NickNameValidationState) {
        self.nickNameValidationStateLabel.text = state.message
        self.nickNameValidationStateLabel.textColor = FlipMateColor.warningRed.color
        self.doneButton.isEnabled = false
    }
    
    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constant.okTitle, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
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
private extension SignUpViewController {
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
        guard let imageData = profileImageView.image?.jpegData(compressionQuality: 0.6) else {
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
                let normalizedImage = self.removedOrientationImage(image)
                self.profileImageView.image = normalizedImage
            }
        }
    }
    
    private func removedOrientationImage(_ image: UIImage) -> UIImage {
        guard image.imageOrientation != .up else { return image }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage ?? image
    }
}

// MARK: - Constants
private extension SignUpViewController {
    enum Constant {
        static let title = NSLocalizedString("profileSetting", comment: "")
        static let done = NSLocalizedString("done", comment: "")
        static let cameraImageName = "camera.fill"
        static let nickNameTextFieldPlaceHolderText = NSLocalizedString("nicknamePlaceHolder", comment: "")
        static let imageNotSafeTitle = NSLocalizedString("imageNotSafeTitle", comment: "")
        static let imageNotSafeMessage = NSLocalizedString("imageNotSafeMessage", comment: "")
        static let okTitle = NSLocalizedString("ok", comment: "")
        static let errorOccurred = NSLocalizedString("errorOccurred", comment: "")
        static let maxLength = 10
    }
    
    enum ProfileImageConstant {
        static let xPos: CGFloat = 0
        static let yPos: CGFloat = 0
        static let width: CGFloat = 100
        static let heigth: CGFloat = 100
        static let top: CGFloat = 64
    }
    
    enum CameraButtonConstant {
        static let topMargin: CGFloat = 8
        static let leftMargin: CGFloat = 16
        static let bottomMargin: CGFloat = 8
        static let rightMargin: CGFloat = 16
        
        static let xPos: CGFloat = 0
        static let yPos: CGFloat = 0
        static let width: CGFloat = 33
        static let height: CGFloat = 33
    }
    
    enum NicknameTextFieldConstant {
        static let top: CGFloat = 16
        static let width: CGFloat = 220
    }
    
    enum NickNameValidationStateLabelConstant {
        static let bottom: CGFloat = 16
    }
    
    enum TextFieldUnderlineConstant {
        static let xPos: CGFloat = 0
        static let height: CGFloat = 1.5
    }
    
    enum DoneButtonConstant {
        static let topInset: CGFloat = 16
        static let leadingInset: CGFloat = 32
        static let bottomInset: CGFloat = 16
        static let trailingInset: CGFloat = 32
        static let title = NSLocalizedString("signUp", comment: "")
        static let cornerRaidus: CGFloat = 15
        
        static let bottom: CGFloat = -32
        static let leading: CGFloat = 32
        static let trailing: CGFloat = -32
    }
}
