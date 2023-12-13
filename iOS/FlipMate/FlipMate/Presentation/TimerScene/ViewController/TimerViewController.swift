//
//  TimerViewController.swift
//  FlipMate
//
//  Created by 권승용 on 11/13/23.
//

import UIKit
import Combine
import OSLog

final class TimerViewController: BaseViewController {
    typealias CateogoryDataSource = UICollectionViewDiffableDataSource<CategorySettingSection, CategorySettingItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CategorySettingSection, CategorySettingItem>
    
    // MARK: - Properties
    private var timerViewModel: TimerViewModelProtocol
    private let deviceMotionManager = DeviceMotionManager.shared
    private let feedbackManager = FeedbackManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: CateogoryDataSource?
    
    // MARK: - init
    init(timerViewModel: TimerViewModelProtocol) {
        self.timerViewModel = timerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    /// 오늘 학습한 총 시간 타이머
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.startTime
        label.font = FlipMateFont.extraLargeBold.font
        label.textColor = .label
        return label
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .gray
        return divider
    }()
    
    private lazy var categoryListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryListCollectionViewCell.self)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var categorySettingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: Constant.categoryManageButtonImageName), for: .normal)
        button.setTitle(Constant.categoryManageButtonTitle, for: .normal)
        button.setTitleColor(FlipMateColor.gray1.color, for: .normal)
        button.tintColor = FlipMateColor.gray1.color
        button.layer.borderWidth = 1.0
        button.layer.borderColor = FlipMateColor.gray1.color?.cgColor
        button.layer.cornerRadius = 8.0
        button.addTarget(self, action: #selector(categorySettingButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var instructionImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .instruction)
        return image
    }()
    
    // MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
        setSnapshot()
        configureTimeZoneNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.isProximityMonitoringEnabled = true
        configureProximityNotification()
        timerViewModel.viewWillAppear()
    }
    
    // swiftlint:disable notification_center_detachment
    override func viewDidDisappear(_ animated: Bool) {
        deviceMotionManager.stopDeviceMotion()
        timerViewModel.viewDidDisappear()
        UIDevice.current.isProximityMonitoringEnabled = false
        removeProximityNotification()
    }
    // swiftlint:enable notification_center_detachment
    
    // MARK: - setup UI
    override func configureUI() {
        let subViews = [timerLabel,
                        divider,
                        categoryListCollectionView,
                        categorySettingButton,
                        instructionImage
        ]
        
        subViews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 30),
            divider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            categoryListCollectionView.topAnchor.constraint(equalTo: categorySettingButton.bottomAnchor, constant: 10),
            categoryListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoryListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            categorySettingButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            categorySettingButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            categorySettingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categorySettingButton.widthAnchor.constraint(equalToConstant: 90),
            categorySettingButton.heightAnchor.constraint(equalToConstant: 32)
            
        ])
        
        NSLayoutConstraint.activate([
            instructionImage.topAnchor.constraint(equalTo: categorySettingButton.bottomAnchor, constant: 30),
            instructionImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func bind() {
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
                self.timerLabel.text = totalTime.secondsToStringTime()
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
            }
            .store(in: &cancellables)
        
        timerViewModel.deviceSettingEnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                print("넘어옵니다.", isEnabled)
                self?.setDeviceSetting(isEnabled: isEnabled)
            }
            .store(in: &cancellables)
    }
    
    func saveStudyLog() {
        timerViewModel.saveStudyLog()
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

// MARK: - TimeZone Notification
private extension TimerViewController {
    func configureTimeZoneNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeTimeZone),
            name: NSNotification.Name.NSSystemTimeZoneDidChange,
            object: nil)
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
    
    @objc func didChangeTimeZone() {
        // MARK: - 타임존 대응
        FMLogger.device.log("타임존이 바꼈습니다. TimerViewController")
    }
}

// MARK: - DiffableDataSource
private extension TimerViewController {
    func setDataSource() {
        dataSource = CateogoryDataSource(collectionView: categoryListCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .categoryCell(let category):
                let cell: CategoryListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.updateUI(category: category)
                cell.updateShadow()
                cell.setTimeLabelHidden(isHidden: false)
                return cell
            }
        })
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
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 20, height: 58)
    }
    
    /// 위아래 간격
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension TimerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryListCollectionViewCell else { return }
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        timerViewModel.categoryDidSelected(category: item.category)
        cell.updateShadow()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryListCollectionViewCell else { return }
        cell.updateShadow()
    }
}

// MARK: - Constants
private extension TimerViewController {
    enum Constant {
        static let startTime = "00:00:00"
        static let categoryManageButtonImageName = "gearshape"
        static let categoryManageButtonTitle = NSLocalizedString("setting", comment: "")
    }
}
