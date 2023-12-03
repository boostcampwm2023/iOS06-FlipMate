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
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Friend>
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
                var snapshot = NSDiffableDataSourceSnapshot<Section, Friend>()
                snapshot.appendSections([.main])
                snapshot.appendItems(friends.map { Friend(
                    id: $0.id,
                    nickName: $0.nickName,
                    profileImageURL: $0.profileImageURL,
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let indexPath = friendsCollectionView.indexPathsForSelectedItems?.first else { return }
        guard let item = self.diffableDataSource?.itemIdentifier(for: indexPath) else { return }
        viewModel.friendCellDidTapped(friend: item)
    }
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
