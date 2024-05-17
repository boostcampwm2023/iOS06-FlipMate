//
//  TimerHeaderView.swift
//  FlipMate
//
//  Created by 임현규 on 2023/12/14.
//

import UIKit
import Combine
import DesignSystem

final class TimerHeaderView: UICollectionReusableView {
    // MARK: - Constants
    private enum Constant {
        static let startTime = "00:00:00"
        static let categoryManageButtonImageName = "gearshape"
        static let categoryManageButtonTitle = NSLocalizedString("setting", comment: "")
    }
    
    private enum CategoryButtonConstant {
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static let bottom: CGFloat = 10
        static let trailing: CGFloat = -16
        static let width: CGFloat = 90
        static let height: CGFloat = 32
    }
    
    private enum DividerConstant {
        static let bottom: CGFloat = 30
        static let height: CGFloat = 1
    }
    
    // MARK: - Properties
    private var categorySettingSubejct = PassthroughSubject<Void, Never>()
    var cancellable: AnyCancellable?

    // MARK: - UI Components
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
        button.layer.borderWidth = CategoryButtonConstant.borderWidth
        button.layer.borderColor = FlipMateColor.gray1.color?.cgColor
        button.layer.cornerRadius = CategoryButtonConstant.cornerRadius
        button.addTarget(self, action: #selector(categorySettingButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    // MARK: - Methods
    func categoryTapPublisher() -> AnyPublisher<Void, Never> {
        return categorySettingSubejct.eraseToAnyPublisher()
    }
    
    func updateTotalTime(time: Int) {
        timerLabel.text = time.secondsToStringTime()
    }
}

// MARK: - UI Setting
private extension TimerHeaderView {
    func configureUI() {
        [ timerLabel, divider, categorySettingButton ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: topAnchor),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            divider.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: DividerConstant.bottom),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: DividerConstant.height),
            
            categorySettingButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: CategoryButtonConstant.bottom),
            categorySettingButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            categorySettingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CategoryButtonConstant.trailing),
            categorySettingButton.widthAnchor.constraint(equalToConstant: CategoryButtonConstant.width),
            categorySettingButton.heightAnchor.constraint(equalToConstant: CategoryButtonConstant.height)
        ])
    }
}

// MARK: - objc func
private extension TimerHeaderView {
    @objc func categorySettingButtonDidTapped() {
        categorySettingSubejct.send()
    }
}
