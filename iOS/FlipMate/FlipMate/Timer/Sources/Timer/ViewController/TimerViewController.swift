//
//  TimerViewController.swift
//
//
//  Created by 권승용 on 5/30/24.
//

import UIKit
import Combine
import OSLog
import Core
import DesignSystem

public final class TimerViewController: BaseViewController {
    typealias CateogoryDataSource = UICollectionViewDiffableDataSource<CategorySettingSection, CategorySettingItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CategorySettingSection, CategorySettingItem>
    
    // MARK: - Properties
    private var timerViewModel: TimerViewModelProtocol
    private let deviceMotionManager = DeviceMotionManager.shared
    private let feedbackManager = FeedbackManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: CateogoryDataSource?
    
    // MARK: - View Properties
    private lazy var categoryListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryListCollectionViewCell.self)
        collectionView.register(TimerHeaderView.self, kind: .header)
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshStudyLog), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var instructionImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Constant.instructionImageName)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()
    
    // MARK: - init
    public init(timerViewModel: TimerViewModelProtocol) {
        self.timerViewModel = timerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    // MARK: - View LifeCycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
        setSnapshot()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.isProximityMonitoringEnabled = true
        configureProximityNotification()
        timerViewModel.viewWillAppear()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        deviceMotionManager.stopDeviceMotion()
        timerViewModel.viewDidDisappear()
        UIDevice.current.isProximityMonitoringEnabled = false
        removeProximityNotification()
    }
    
    // MARK: - setup UI
    public override func configureUI() {
        view.addSubview(categoryListCollectionView)
        categoryListCollectionView.addSubview(instructionImage)
        
        NSLayoutConstraint.activate([
            categoryListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoryListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            instructionImage.centerXAnchor.constraint(equalTo: categoryListCollectionView.centerXAnchor),
            instructionImage.centerYAnchor.constraint(equalTo: categoryListCollectionView.centerYAnchor)
        ])
    }
    
    public override func bind() {
        timerViewModel.viewDidLoad()
        
        timerViewModel.isDeviceFaceDownPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFaceDown in
                guard let self = self else { return }
                self.startHapticFeedback(isFaceDown)
            }
            .store(in: &cancellables)
        
        timerViewModel.totalTimePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totalTime in
                guard let self = self else { return }
                let header = findHeader()
                header?.updateTotalTime(time: totalTime)
            }
            .store(in: &cancellables)
        
        deviceMotionManager.orientationDidChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newOrientation in
                guard let self = self else { return }
                self.handleOrientationChange(newOrientation)
            }
            .store(in: &cancellables)
        
        timerViewModel.categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                guard let self = self else { return }
                if !categories.isEmpty {
                    self.instructionImage.isHidden = true
                } else {
                    self.instructionImage.isHidden = false
                }
                guard var snapShot = self.dataSource?.snapshot() else { return }
                let sections: [CategorySettingSection] = [.categorySection([])]
                snapShot.deleteAllItems()
                snapShot.appendSections(sections)
                snapShot.appendItems(categories.map { CategorySettingItem.categoryCell($0) })
                self.dataSource?.apply(snapShot)
                self.setInstructionImage()
            }
            .store(in: &cancellables)
        
        timerViewModel.deviceSettingEnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                guard let self = self else { return }
                self.setDeviceSetting(isEnabled: isEnabled)
            }
            .store(in: &cancellables)
    }
    
    public func saveStudyLog() {
        timerViewModel.refreshStudyLog()
    }
    
    @objc func refreshStudyLog() {
        timerViewModel.refreshStudyLog()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
            self?.categoryListCollectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: Prviate Method
private extension TimerViewController {
    func startHapticFeedback(_ isFaceDown: Bool) {
        if isFaceDown {
            feedbackManager.startFacedownFeedback()
        } else {
            feedbackManager.startFaceupFeedback()
        }
    }
    
    func setDeviceSetting(isEnabled: Bool) {
        if isEnabled {
            deviceMotionManager.startDeviceMotion()
        } else {
            deviceMotionManager.stopDeviceMotion()
        }
    }
    
    func findHeader() -> TimerHeaderView? {
        guard let header = categoryListCollectionView.visibleSupplementaryViews(
            ofKind: UICollectionView.elementKindSectionHeader).first
                as? TimerHeaderView else { return nil }
        return header
    }
    
    func setInstructionImage() {
        let snapshot = dataSource?.snapshot()
        let numberOfItems = snapshot?.numberOfItems
        
        if numberOfItems == .zero {
            instructionImage.isHidden = false
        } else {
            instructionImage.isHidden = true
        }
    }
}

// MARK: Detecting FaceDown Method
private extension TimerViewController {
    func configureProximityNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(proximityDidChange(_:)),
            name: UIDevice.proximityStateDidChangeNotification,
            object: nil)
    }
    
    func removeProximityNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.proximityStateDidChangeNotification,
            object: nil)
    }
    
    func handleOrientationChange(_ orientation: UIDeviceOrientation) {
        guard let deviceOrientation = DeviceOrientation(rawValue: orientation.rawValue) else { return }
        timerViewModel.deviceOrientationDidChange(deviceOrientation)
    }
}

// MARK: objc function
private extension TimerViewController {
    @objc func proximityDidChange(_ notification: Notification) {
        guard let device = notification.object as? UIDevice else { return }
        let deviceProximityStatus = device.proximityState
        timerViewModel.deviceProximityDidChange(deviceProximityStatus)
    }
    
    @objc func categorySettingButtonDidTapped() {
        timerViewModel.categorySettingButtoneDidTapped()
    }
}

// MARK: - DiffableDataSource
private extension TimerViewController {
    func setDataSource() {
        dataSource = CateogoryDataSource(collectionView: categoryListCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .categoryCell(let category):
                let cell: CategoryListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.updateUI(category.subject, UIColor(hexString: category.color), category.studyTime?.secondsToStringTime())
                cell.updateShadow()
                cell.setTimeLabelHidden(isHidden: false)
                return cell
            }
        })
        
        dataSource?
            .supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
                let header: TimerHeaderView = collectionView
                    .dequeueReusableView(for: indexPath, kind: kind)
                header.cancellable = header.categoryTapPublisher()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] _ in
                        self?.timerViewModel.categorySettingButtoneDidTapped()
                    }
                return header
            }
    }
    
    func setSnapshot() {
        var snapshot = Snapshot()
        let sections: [CategorySettingSection] = [.categorySection([])]
        snapshot.appendSections(sections)
        dataSource?.apply(snapshot)
    }
}

// MARK: CollectionView function
extension TimerViewController: UICollectionViewDelegateFlowLayout {
    
    /// cell size
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: view.frame.size.width - CollectionViewConstant.cellSpacing,
            height: CollectionViewConstant.cellHeight)
    }
    
    /// 위아래 간격
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewConstant.sectionSpacing
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(
                top: CollectionViewConstant.sectionTopInset,
                left: CollectionViewConstant.sectionLeftInset,
                bottom: CollectionViewConstant.sectionBottomInset,
                right: CollectionViewConstant.sectionRightInset)
        }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(
                width: CollectionViewConstant.sectionWidth,
                height: CollectionViewConstant.sectionHeight)
        }
}

extension TimerViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryListCollectionViewCell else { return true }
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            cell.updateShadow()
            timerViewModel.categoryDidDeselected()
            return false
        } else {
            return true
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryListCollectionViewCell else { return }
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        timerViewModel.categoryDidSelected(category: item.category)
        cell.updateShadow()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryListCollectionViewCell else { return }
        cell.updateShadow()
    }
}

// MARK: - Constants
private extension TimerViewController {
    enum Constant {
        static let instructionImageName = NSLocalizedString("instruction", comment: "")
    }
    
    enum CollectionViewConstant {
        static let cellHeight: CGFloat = 58
        static let cellSpacing: CGFloat = 20
        
        static let sectionSpacing: CGFloat = 10
        static let sectionTopInset: CGFloat = 0
        static let sectionLeftInset: CGFloat = 0
        static let sectionBottomInset: CGFloat = 60
        static let sectionRightInset: CGFloat = 0
        static let sectionWidth: CGFloat = 200
        static let sectionHeight: CGFloat = 150
    }
}
