//
//  SocialViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

import UIKit
import Combine

final class SocialViewController: BaseViewController {
    
    // MARK: - View Properties
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(resource: .defaultProfile)
        imageView.clipsToBounds = true
        imageView.bounds = CGRect(x: 0, y: 0, width: 90, height: 90)
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.text = "닉네임"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var learningTimeLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.text = "00:00:00"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .gray
        return divider
    }()
    
    private lazy var friendsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.0 - 32, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FriendsCollectionViewCell.self)
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Properties
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, FriendUser>
    private var diffableDataSource: DiffableDataSource!
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: SocialViewModelProtocol
    
    // MARK: - init
    init(viewModel: SocialViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use Storyboard")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDiffableDataSource()
        configureNavigationBarItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    // MARK: - Configure UI
    override func configureUI() {
        title = Constant.title
        
        let subviews = [
            profileImageView,
            userNameLabel,
            learningTimeLabel,
            divider,
            friendsCollectionView
        ]
        
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 90),
            profileImageView.heightAnchor.constraint(equalToConstant: 90),
            
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            learningTimeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            learningTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            divider.topAnchor.constraint(equalTo: learningTimeLabel.bottomAnchor, constant: 24),
            divider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            friendsCollectionView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            friendsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            friendsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            friendsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureDiffableDataSource() {
        diffableDataSource = DiffableDataSource(collectionView: friendsCollectionView) { collectionView, indexPath, friend in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FriendsCollectionViewCell.identifier,
                for: indexPath) as? FriendsCollectionViewCell else {
                preconditionFailure()
            }
            cell.configure(friend: friend)
            return cell
        }
    }
    
    private func configureNavigationBarItems() {
        let myPageButton = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .plain,
            target: self,
            action: #selector(myPageButtonTapped))
        let addFriendButton = UIBarButtonItem(
            image: UIImage(systemName: "person.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(addFriendButtonTapped))
        myPageButton.tintColor = .label
        addFriendButton.tintColor = .label
        navigationItem.leftBarButtonItem = myPageButton
        navigationItem.rightBarButtonItem = addFriendButton
    }
    
    override func bind() {
        viewModel.viewDidLoad()
        
        viewModel.freindsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] friends in
                guard let self = self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<Section, FriendUser>()
                snapshot.appendSections([.main])
                snapshot.appendItems(friends.map { FriendUser(
                    id: $0.id,
                    profileImageURL: $0.profileImageURL,
                    name: $0.nickName,
                    totalTime: $0.totalTime,
                    isStuding: $0.isStuding)}
                )
                self.diffableDataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
        
        viewModel.nicknamePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nickname in
                guard let self = self else { return }
                self.userNameLabel.text = nickname
            }
            .store(in: &cancellables)
        
        viewModel.updateFriendStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updateFreinds in
                guard let self = self else { return }
                self.updateLearningTime(updateFreinds: updateFreinds)
            }
            .store(in: &cancellables)
        
        viewModel.stopFriendStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stopFriends in
                guard let self = self else { return }
                self.stopLearningTime(stopFriends: stopFriends)
            }
            .store(in: &cancellables)
    }
}

// MARK: - private Methods
private extension SocialViewController {
    func updateLearningTime(updateFreinds: [UpdateFriend]) {
        guard let snapshot = diffableDataSource?.snapshot() else { return }
        let items = snapshot.itemIdentifiers
        for item in items {
            guard let indexPath = diffableDataSource.indexPath(for: item) else {
                continue }
            guard let cell = friendsCollectionView.cellForItem(at: indexPath) as? FriendsCollectionViewCell else {
                continue }
            guard let friend = updateFreinds.filter { $0.id == item.id }.first else {
                continue }
            cell.updateLearningTime(friend.currentLearningTime)
        }
    }
    
    func stopLearningTime(stopFriends: [StopFriend]) {
        guard let snpshot = diffableDataSource?.snapshot() else { return }
        let items = snpshot.itemIdentifiers
        for item in items {
            guard let indexPath = diffableDataSource.indexPath(for: item) else { continue }
            guard let cell = friendsCollectionView.cellForItem(at: indexPath) as? FriendsCollectionViewCell else { continue }
            guard let friend = stopFriends.filter { $0.id == item.id }.first else { continue }
            cell.stopLearningTime(friend.totalTime)
        }
    }
}

// MARK: - Selector methods
private extension SocialViewController {
    @objc
    func myPageButtonTapped() {
        self.navigationController?.pushViewController(MyPageViewController(), animated: true)
    }
    
    @objc
    func addFriendButtonTapped() {
        viewModel.freindAddButtonDidTapped()
    }
}

// MARK: - UICollectionViewDelegate
extension SocialViewController: UICollectionViewDelegate {
    
}

// MARK: - Constants
private extension SocialViewController {
    enum Constant {
        static let title = "소셜"
    }
}

//@available(iOS 17, *)
//#Preview {
//    SocialViewController()
//}
