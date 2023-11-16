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
    private var feedbackManager: FeedbackManager
    private let deviceMotionManager = DeviceMotionManager.shared
    private var cancellabes = Set<AnyCancellable>()
    private var userScreenBrightness: CGFloat = UIScreen.main.brightness
    private var logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "test")
    // MARK: - init
    init(timerViewModel: TimerViewModelProtocol, feedbackManager: FeedbackManager) {
        self.timerViewModel = timerViewModel
        self.feedbackManager = feedbackManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    /// 오늘 학습한 총 시간 타이머
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
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
    
    private lazy var categoryManageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.setTitle("관리", for: .normal)
        button.setTitleColor(FlipMateColor.gray1.color, for: .normal)
        button.tintColor = FlipMateColor.gray1.color
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
                        categoryManageButton,
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
            categoryListCollectionView.topAnchor.constraint(equalTo: categoryManageButton.bottomAnchor, constant: 10),
            categoryListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            categoryManageButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            categoryManageButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryManageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            
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
            }
            .store(in: &cancellabes)

        timerViewModel.totalTimePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totalTime in
                guard let self = self else { return }
                self.timerLabel.text = totalTime.secondsToStringTime()
            }
            .store(in: &cancellabes)

        deviceMotionManager.orientationDidChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newOrientation in
                guard let self = self else { return }
                self.handleOrientationChange(newOrientation)
            }
            .store(in: &cancellabes)
    }
}

private extension TimerViewController {
    func setScreenBrightness(_ isFaceDown: Bool) {
        if isFaceDown {
            self.userScreenBrightness = UIScreen.main.brightness
            self.feedbackManager.startFacedownFeedback()
            UIScreen.main.brightness = 0.0
        } else {
            self.feedbackManager.startFaceupFeedback()
            UIScreen.main.brightness = self.userScreenBrightness
        }
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
        UIDevice.current.isProximityMonitoringEnabled = orientation == .faceDown ? true : false
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
}

// MARK: CollectionView function
extension TimerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        return CGSize(width: 363, height: 58)
    }
    
    /// 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    TimerViewController(timerViewModel: TimerViewModel(timerUseCase: DefaultTimerUseCase()), feedbackManager: FeedbackManager())
//}
