//
//  FollowingsViewController.swift
//  FlipMate
//
//  Created by 신민규 on 1/16/24.
//

import UIKit
import Combine

final class FollowingsViewController: BaseViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let viewModel: FollowingsViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    typealias DiffableDataSource = UITableViewDiffableDataSource<Section, Follower>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Follower>
    private var dataSource: DiffableDataSource!
    
    init(viewModel: FollowingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    override func viewDidLoad() {
        viewModel.fetchFollowings()
    }
    
    override func configureUI() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.tableView.register(FollowTableViewCell.self, forCellReuseIdentifier: FollowTableViewCell.identifier)
        self.view.addSubview(tableView)
        configureDatasource()
    }
    
    override func bind() {
        viewModel.followingsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] follower in
                guard let self = self else { return }
                self.updateData(by: follower)
            }
            .store(in: &cancellables)
    }
    
    private func updateData(by follower: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(follower)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func configureDatasource() {
        dataSource = UITableViewDiffableDataSource<Section, Follower>(tableView: tableView, cellProvider: { tableView, indexPath, follower in
            let cell = tableView.dequeueReusableCell(withIdentifier: FollowTableViewCell.identifier, for: indexPath) as? FollowTableViewCell
            cell?.configureCell(imageUrl: follower.profileImageURL ?? "", title: follower.nickName, buttonTitle: "팔로우")
            return cell
        })
    }
}
