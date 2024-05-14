//
//  FriendAddViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/28.
//

import Core
import UIKit
import Combine

final class FriendAddViewController: BaseViewController {
    // MARK: - Constant
    private enum NameTextFieldConstant {
        static let top: CGFloat = 20
        static let leading: CGFloat = 40
        static let height: CGFloat = 20
        static let placeholder = NSLocalizedString("friendNickname", comment: "")
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
    
    private enum ContainerViewConstant {
        static let top: CGFloat = 15
        static let leading: CGFloat = 40
        static let trailing: CGFloat = -40
    }
    
    private enum Constant {
        static let maxLength = 10
        static let cancel = NSLocalizedString("cancel", comment: "")
        static let errorMessage = NSLocalizedString("tryAgain", comment: "")
    }
    
    // MARK: - Properties
    private let viewModel: FriendAddViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components
    private lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NameTextFieldConstant.placeholder
        textField.becomeFirstResponder()
        textField.delegate = self
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
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.cancel, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private let containerView = UIView()
    private let myNickNameView = MyNickNameView()
    private let noResultView = NoResultView()
    private let friendSearchResultView = FriendSearchResultView()
    
    // MARK: - init
    init(viewModel: FriendAddViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateResultView(myNickNameView)
        configureNavigationBar()
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
            
            containerView.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: ContainerViewConstant.top),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ContainerViewConstant.leading),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ContainerViewConstant.trailing),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func bind() {
        viewModel.searchFreindPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] friendSearchItem in
                guard let self = self else { return }
                self.friendSearchResultView.updateUI(friendSearchItem: friendSearchItem)
                self.updateResultView(friendSearchResultView)
            }
            .store(in: &cancellables)
        
        viewModel.searchErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                FMLogger.general.error("에러 발생 : \(error)")
                self.updateResultView(noResultView)
            }
            .store(in: &cancellables)
        
        viewModel.nicknameCountPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                guard let self = self else { return }
                self.nickNameCountLabel.text = "\(count)/\(Constant.maxLength)"
            }
            .store(in: &cancellables)
        
        viewModel.myNicknamePublihser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] myNickname in
                guard let self = self else { return }
                self.myNickNameView.updateUI(nickname: myNickname)
            }
            .store(in: &cancellables)
        
        friendSearchResultView.tapPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.didFollowFriend()
            }
            .store(in: &cancellables)
        
        viewModel.followErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showToast(title: Constant.errorMessage)
            }
            .store(in: &cancellables)
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
    
    func configureNavigationBar() {
        navigationItem.title = NSLocalizedString("addFriend", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
    }
}

// MARK: - Objc func
private extension FriendAddViewController {
    @objc func dismissButtonDidTapped() {
        viewModel.dismissButtonDidTapped()
    }
}

// MARK: - UITextFieldDelegate
extension FriendAddViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let nickname = textField.text else { return }
        guard nickname.count <= Constant.maxLength else {
            textField.deleteBackward()
            textField.resignFirstResponder()
            return
        }
        viewModel.nicknameDidChange(at: nickname)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text != nil else { return false }
        viewModel.didSearchFriend()
        return true
    }
}
