//
//  MyPageViewController.swift
//  FlipMate
//
//  Created by 권승용 on 11/30/23.
//

import UIKit
import Combine

final class MyPageViewController: BaseViewController {
    // MARK: - View Properties
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .defaultProfile)
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var userNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumRegular.font
        label.text = UserInfoStorage.nickname
        label.textColor = .label
        return label
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = FlipMateColor.gray5.color
        return divider
    }()
    
    private lazy var myPageTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            MyPageTableViewCell.self,
            forCellReuseIdentifier: MyPageTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 55
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Properties
    private let viewModel: MyPageViewModelProtocol
    private var myPageDataSource = [[String]]()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    init(viewModel: MyPageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("can't use this, no storyboard")
    }
    
    // MARK: - View LifeCycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewReady()
    }
    
    // MARK: - UI Configurations
    override func configureUI() {
        title = Constant.title
        
        let subviews = [
            profileImageView,
            userNicknameLabel,
            divider,
            myPageTableView
        ]
        
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            userNicknameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            userNicknameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            divider.topAnchor.constraint(equalTo: userNicknameLabel.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            myPageTableView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            myPageTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myPageTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            myPageTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    // MARK: - Binding
    override func bind() {
        viewModel.nicknamePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nickname in
                guard let self = self else { return }
                self.userNicknameLabel.text = nickname
            }
            .store(in: &cancellables)
        
        viewModel.imageURLPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageURL in
                guard let self = self else { return }
                self.profileImageView.setImage(url: imageURL)
            }
            .store(in: &cancellables)
        
        viewModel.tableViewDataSourcePublisher
            .sink { [weak self] data in
                self?.myPageDataSource = data
                DispatchQueue.main.async {
                    self?.myPageTableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .sink { error in
                FMLogger.general.error("에러 발생 : \(error)")
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as? MyPageTableViewCell else {
            return MyPageTableViewCell()
        }
        cell.configureCell(title: myPageDataSource[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = FlipMateColor.gray5.color
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 0
        } else {
            return 1
        }
    }
}

// MARK: - UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 프로필 수정 탭
        // TODO: 코디네이터 패턴 적용
        if indexPath.section == 0, indexPath.row == 0 {
            navigationController?.pushViewController(
                ProfileSettingsViewController(
                    viewModel: ProfileSettingsViewModel(
                        usecase: DefaultProfileSettingsUseCase(
                            repository: DefaultProfileSettingsRepository(
                                provider: Provider(urlSession: URLSession.shared, signOutManager: SignOutManager.shared)),
                            validator: NickNameValidator()),
                        actions: ProfileSettingsViewModelActions(didFinishSignUp: {}))),
                animated: true)
        }
        
        if indexPath.section == 1 {
            // 문의하기 탭
            if indexPath.row == 0 {
            
            }
            
            // 개발자 정보 탭
            if indexPath.row == 1 {
                
            }
            
            // 버전 정보 탭
            if indexPath.row == 2 {
                
            }
        }
        
        if indexPath.section == 2 {
            // 데이터 초기화 탭
            if indexPath.row == 0 {
                
            }
            
            // 로그아웃 탭
            if indexPath.row == 1 {
                viewModel.signOutButtonTapped()
            }
        }
        
        if indexPath.section == 3, indexPath.row == 0 {
            // 계정 탈퇴 탭
        }
        
        myPageTableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Constant
private extension MyPageViewController {
    enum Constant {
        static let title = "마이페이지"
    }
}
