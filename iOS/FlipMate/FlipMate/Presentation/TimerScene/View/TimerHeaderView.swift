//
//  TimerHeaderView.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/14.
//

import UIKit
import Combine

final class TimerHeaderView: UICollectionReusableView {
    private enum Constant {
        static let startTime = "00:00:00"
        static let categoryManageButtonImageName = "gearshape"
        static let categoryManageButtonTitle = NSLocalizedString("setting", comment: "")
        static let instructionImageName = NSLocalizedString("instruction", comment: "")
        static let bottomInset: CGFloat = 50
    }
    
    private var categorySettingSubejct = PassthroughSubject<Void, Never>()
    var cancellable: AnyCancellable?

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    func categoryTapPublisher() -> AnyPublisher<Void, Never> {
        return categorySettingSubejct.eraseToAnyPublisher()
    }
    
    @objc func categorySettingButtonDidTapped() {
        categorySettingSubejct.send()
    }
    
    func updateTotalTime(time: Int) {
        timerLabel.text = time.secondsToStringTime()
    }
}

private extension TimerHeaderView {
    func configureUI() {
        [ timerLabel, divider, categorySettingButton ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: topAnchor),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            divider.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 30),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            categorySettingButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            categorySettingButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            categorySettingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categorySettingButton.widthAnchor.constraint(equalToConstant: 90),
            categorySettingButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}
