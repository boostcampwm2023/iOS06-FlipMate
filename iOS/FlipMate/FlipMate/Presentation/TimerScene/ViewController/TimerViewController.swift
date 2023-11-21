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
    // MARK: - Properties
    private var timerViewModel: TimerViewModelProtocol
    private let deviceMotionManager = DeviceMotionManager.shared
    private let feedbackManager = FeedbackManager()
    private var cancellables = Set<AnyCancellable>()
    private var userScreenBrightness: CGFloat = UIScreen.main.brightness
    
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
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNotification()
        UIDevice.current.isProximityMonitoringEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deviceMotionManager.stopDeviceMotion()
        UIDevice.current.isProximityMonitoringEnabled = false
    }
  
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
            divider.heightAnchor.constraint(equalToConstant: 1),
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
            instructionImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            instructionImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func bind() {
        timerViewModel.isDeviceFaceDownPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFaceDown in
                guard let self = self else { return }
                self.setScreenBrightness(isFaceDown)
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
        
        timerViewModel.isPresentingCategoryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.pushtCategorySettingViewController()
            }
            .store(in: &cancellables)

        deviceMotionManager.orientationDidChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newOrientation in
                guard let self = self else { return }
                self.handleOrientationChange(newOrientation)
            }
            .store(in: &cancellables)
    }
}

// MARK: Prviate Method
private extension TimerViewController {
    func setScreenBrightness(_ isFaceDown: Bool) {
        if isFaceDown {
            self.userScreenBrightness = UIScreen.main.brightness
            UIScreen.main.brightness = 0.0
        } else {
            UIScreen.main.brightness = self.userScreenBrightness
        }
    }
    
    func startHapticFeedback(_ isFaceDown: Bool) {
        if isFaceDown {
            feedbackManager.startFacedownFeedback()
        } else {
            feedbackManager.startFaceupFeedback()
        }
    }
    
    func pushtCategorySettingViewController() {
        let categorySettingViewController = CategorySettingViewController()
        navigationController?.pushViewController(categorySettingViewController, animated: true)
    }
}

// MARK: Detecting FaceDown Method
private extension TimerViewController {
    func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(proximityDidChange(_:)), name: UIDevice.proximityStateDidChangeNotification, object: nil)
        deviceMotionManager.startDeviceMotion()
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

// MARK: CollectionView function
extension TimerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func configureCollectionView() {
        categoryListCollectionView.register(CategoryListCollectionViewCell.self, forCellWithReuseIdentifier: CategoryListCollectionViewCell.identifier)
        categoryListCollectionView.delegate = self
        categoryListCollectionView.dataSource = self
    }
    
    // TODO: Category Model 생성 후 수정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryListCollectionViewCell.identifier, for: indexPath) as? CategoryListCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    /// cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 20, height: 58)
    }
    
    /// 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
        
// MARK: - Constants
private extension TimerViewController {
    enum Constant {
        static let startTime = "00:00:00"
        static let categoryManageButtonImageName = "gearshape"
        static let categoryManageButtonTitle = "관리"
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    TimerViewController(timerViewModel: TimerViewModel(timerUseCase: DefaultTimerUseCase()), feedbackManager: FeedbackManager())
//}
