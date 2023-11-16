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
    
    private lazy var categoryInstructionBlock: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "관리 버튼을 눌러\n카테고리를 설정해주세요"
        label.numberOfLines = 2
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.gray.cgColor
        return view
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
                        categoryInstructionBlock,
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
            categoryInstructionBlock.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 30),
            categoryInstructionBlock.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryInstructionBlock.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            categoryManageButton.topAnchor.constraint(equalTo: categoryInstructionBlock.bottomAnchor, constant: 10),
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

@available(iOS 17.0, *)
#Preview {
    TimerViewController(timerViewModel: TimerViewModel(timerUseCase: DefaultTimerUseCase()), feedbackManager: FeedbackManager())
}
