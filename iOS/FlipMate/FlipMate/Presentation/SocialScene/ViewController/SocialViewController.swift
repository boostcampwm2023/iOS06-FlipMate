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
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFreindsStatus), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var friendsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: LayoutConstant.topInset,
            left: LayoutConstant.leftInset,
            bottom: LayoutConstant.bottomInset,
            right: LayoutConstant.rightInset)
        layout.minimumLineSpacing = LayoutConstant.lineSpacing
        layout.minimumInteritemSpacing = LayoutConstant.itemSpacing
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width / LayoutConstant.itemCountForLine - LayoutConstant.itemSpacing * 2,
            height: LayoutConstant.itemHeight)
        layout.headerReferenceSize = CGSize(width: LayoutConstant.sectionWidth, height: LayoutConstant.sectionHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FriendsCollectionViewCell.self)
        collectionView.register(SocialUserInfoHeaderView.self, kind: .header)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Properties
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Friend>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Friend>
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
        setSnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    // MARK: - Configure UI
    override func configureUI() {
        navigationItem.title = Constant.title
        
        let subviews = [
            friendsCollectionView
        ]
        
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            friendsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        
        diffableDataSource?
            .supplementaryViewProvider = { collectionView, kind, indexPath in
                let header: SocialUserInfoHeaderView = collectionView
                    .dequeueReusableView(for: indexPath, kind: kind)
                
                return header
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
        bindFriendsRelatedPublisher()
                
        viewModel.nicknamePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nickname in
                guard let self = self else { return }
                guard let header = findHeader() else { return }
                header.update(nickname: nickname)
            }
            .store(in: &cancellables)
        
        viewModel.profileImagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageURL in
                guard let self = self else { return }
                guard let header = findHeader() else { return }
                header.update(profileImageURL: imageURL)
            }
            .store(in: &cancellables)
        
        viewModel.totalTimePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totalTime in
                guard let self = self else { return }
                guard let header = findHeader() else { return }
                header.update(learningTime: totalTime)
            }
            .store(in: &cancellables)
    }
    
    func bindFriendsRelatedPublisher() {
        viewModel.freindsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] followings in
                guard let self = self else { return }
                guard let header = findHeader() else { return }
                var snapshot = Snapshot()
                snapshot.appendSections([.main])
                snapshot.appendItems(followings.map { Friend(
                    id: $0.id,
                    nickName: $0.nickName,
                    profileImageURL: $0.profileImageURL,
                    totalTime: $0.totalTime,
                    startedTime: $0.startedTime,
                    isStuding: $0.isStuding)}
                )
                header.update(following: followings.count)
                self.diffableDataSource.apply(snapshot, animatingDifferences: true)
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
            guard let friend = updateFreinds.filter({ $0.id == item.id }).first else {
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
            guard let friend = stopFriends.filter({ $0.id == item.id }).first else { continue }
            cell.stopLearningTime(friend.totalTime)
        }
    }
    
    func findHeader() -> SocialUserInfoHeaderView? {
        guard let header = friendsCollectionView.visibleSupplementaryViews(
            ofKind: UICollectionView.elementKindSectionHeader).first
                as? SocialUserInfoHeaderView else { return nil }
        return header
    }
    
    func setSnapshot() {
        var snapshot = Snapshot()
        let sections: [Section] = [.main]
        snapshot.appendSections(sections)
        diffableDataSource?.apply(snapshot)
    }
}

// MARK: - Selector methods
private extension SocialViewController {
    @objc func myPageButtonTapped() {
        viewModel.myPageButtonTapped()
    }
    
    @objc func addFriendButtonTapped() {
        viewModel.freindAddButtonDidTapped()
    }
    
    @objc func refreshFreindsStatus() {
        viewModel.didRefresh()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
            self?.friendsCollectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SocialViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let indexPath = friendsCollectionView.indexPathsForSelectedItems?.first else { return }
        guard let item = self.diffableDataSource?.itemIdentifier(for: indexPath) else { return }
        viewModel.friendCellDidTapped(friend: item)
    }
}

// MARK: - Constants
private extension SocialViewController {
    enum Constant {
        static let title = NSLocalizedString("social", comment: "")
    }

    private enum LayoutConstant {
        static var topInset: CGFloat = 24
        static var leftInset: CGFloat = 16
        static var bottomInset: CGFloat = 42
        static var rightInset: CGFloat = 16
        
        static var lineSpacing: CGFloat = 16
        static var itemSpacing: CGFloat = 16
        static var itemHeight: CGFloat = 179
        static var itemCountForLine = 3.0
        
        static var sectionWidth: CGFloat = 50
        static var sectionHeight: CGFloat = 110
    }
    
    private enum ProfileImageViewConstant {
        static var width: CGFloat = 90
        static var height: CGFloat = 90
        static var top: CGFloat = 32
    }
    
    private enum UserNameLabelConstant {
        static var bottom: CGFloat = 8
        static var title = "닉네임"
    }
    
    private enum LearningTimeLabelConstant {
        static var bottom: CGFloat = 8
        static var title = "00:00:00"
    }
}
