//
//  SocialDetailViewController.swift
//  FlipMate
//
//  Created by 신민규 on 11/28/23.
//

import UIKit
import SwiftUI
import Combine
import DesignSystem

final class SocialDetailViewController: BaseViewController {
    private enum ComponentConstant {
        static let dailyStudyLog = NSLocalizedString("dailyStudyLog", comment: "")
        static let weeklyStudyLog = NSLocalizedString("weeklyStudyLog", comment: "")
        static let primaryCategory = NSLocalizedString("primaryCategory", comment: "")
        static let primaryCategoryNil = NSLocalizedString("primaryCategoryNil", comment: "")
        static let unfollow = NSLocalizedString("unfollow", comment: "")
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static let spacing1: CGFloat = 1
        static let spacing2: CGFloat = 12
        static let cancelNavigationButton = NSLocalizedString("cancel", comment: "")
        static let navigationTitle = NSLocalizedString("SocialDetailTitle", comment: "")
    }
    
    private enum LayoutConstant {
        static let profileImageTop: CGFloat = 36
        static let profileImageLeading: CGFloat = 15
        static let profileImageHeight: CGFloat = 50
        static let profileImageWidth: CGFloat = 50
        
        static let nicknameLabelLeading: CGFloat = 12
        static let nicknameLabelHeight: CGFloat = 25
        
        static let unfollowButtonTrailing: CGFloat = -20
        static let unfollowButtonHeight: CGFloat = 34
        
        static let dividerTop: CGFloat = 16
        static let dividerHeight: CGFloat = 1
        
        static let studyLogTop: CGFloat = 32
        static let studyLogLeading: CGFloat = 30
        static let stduyLogHeight: CGFloat = 120
        
        static let studyTimeTrailing: CGFloat = -30
        static let studyTimeHeight: CGFloat = 120
        
        static let chartTop: CGFloat = 30
        static let chartLeading: CGFloat = 8
        static let chartTrailing: CGFloat = -8
        static let chartBottom: CGFloat = -30
    }

    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = FlipMateColor.gray2.color
        imageView.layer.cornerRadius = LayoutConstant.profileImageWidth / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle(ComponentConstant.cancelNavigationButton, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = FlipMateFont.semiLargeBold.font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var unfollowButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(ComponentConstant.unfollow, for: .normal)
        button.backgroundColor = FlipMateColor.darkBlue.color
        button.titleLabel?.font = FlipMateFont.mediumBold.font
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        button.layer.borderWidth = ComponentConstant.borderWidth
        button.layer.cornerRadius = ComponentConstant.cornerRadius
        button.addTarget(self, action: #selector(unfollowButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .gray
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        return divider
    }()
    
    private lazy var dailyStudyLogLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumRegular.font
        label.textColor = .label
        label.textAlignment = .center
        label.text = ComponentConstant.dailyStudyLog
        
        return label
    }()
    
    private lazy var weeklyStudyLogLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumRegular.font
        label.textColor = .label
        label.textAlignment = .center
        label.text = ComponentConstant.weeklyStudyLog
        
        return label
    }()
    
    private lazy var primaryCategoryDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumRegular.font
        label.textColor = .label
        label.textAlignment = .center
        label.text = ComponentConstant.primaryCategory
        
        return label
    }()
    
    private lazy var studyLogStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = ComponentConstant.spacing1
        
        return stackView
    }()
    
    private lazy var dailyStudyTimeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumBold.font
        label.textColor = FlipMateColor.gray2.color
        label.textAlignment = .right

        return label
    }()
    
    private lazy var weeklyStudyTimeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumBold.font
        label.textColor = FlipMateColor.gray2.color
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var primaryCategoryLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FlipMateFont.mediumBold.font
        label.textAlignment = .right
        label.textColor = FlipMateColor.gray2.color
        label.text = ComponentConstant.primaryCategoryNil
        
        return label
    }()
    
    private lazy var studyTimeStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = ComponentConstant.spacing2
        
        return stackView
    }()
    
    private var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.backgroundColor = .systemBackground
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        return lineChartView
    }()
    
    private var labelListView: LabelListView = {
        let labelListView = LabelListView()
        labelListView.translatesAutoresizingMaskIntoConstraints = false
        return labelListView
    }()
    
    // MARK: - Properties
    private var viewModel: SocialDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SocialDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    // MARK: - View Life Cycles
    
    // swiftlint:disable function_body_length
    override func configureUI() {
        setStudyLogStackView()
        setStudyTimeStackView()
        configureNavigationBar()
        
        [scrollView, profileImageView, nickNameLabel, unfollowButton, divider].forEach {
            view.addSubview($0)
        }
        
        [studyLogStackView, studyTimeStackView, lineChartView, labelListView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: LayoutConstant.profileImageTop),
            profileImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, 
                                                      constant: LayoutConstant.profileImageLeading),
            profileImageView.heightAnchor.constraint(equalToConstant: LayoutConstant.profileImageHeight),
            profileImageView.widthAnchor.constraint(equalToConstant: LayoutConstant.profileImageWidth),
            
            nickNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: LayoutConstant.nicknameLabelLeading),
            nickNameLabel.trailingAnchor.constraint(equalTo: unfollowButton.leadingAnchor),
            nickNameLabel.heightAnchor.constraint(equalToConstant: LayoutConstant.nicknameLabelHeight),
            
            unfollowButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            unfollowButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, 
                                                     constant: LayoutConstant.unfollowButtonTrailing),
            unfollowButton.heightAnchor.constraint(equalToConstant: LayoutConstant.unfollowButtonHeight)
        ])
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: LayoutConstant.dividerTop),
            divider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: LayoutConstant.dividerHeight)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            studyLogStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstant.studyLogTop),
            studyLogStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                       constant: LayoutConstant.studyLogLeading),
            studyLogStackView.heightAnchor.constraint(equalToConstant: LayoutConstant.stduyLogHeight),
            
            studyTimeStackView.topAnchor.constraint(equalTo: studyLogStackView.topAnchor),
            studyTimeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                         constant: LayoutConstant.studyTimeTrailing),
            studyTimeStackView.heightAnchor.constraint(equalTo: studyLogStackView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: studyLogStackView.bottomAnchor, constant: LayoutConstant.chartTop),
            lineChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstant.chartLeading),
            lineChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstant.chartTrailing),
            lineChartView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            labelListView.topAnchor.constraint(equalTo: lineChartView.bottomAnchor),
            labelListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstant.chartLeading),
            labelListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstant.chartTrailing),
            labelListView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // swiftlint:enable function_body_length
    }
    
    override func bind() {
        viewModel.viewDidLoad()
        
        viewModel.friendPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] friend in
                guard let self = self else { return }
                self.nickNameLabel.text = friend.nickName
                self.dailyStudyTimeLabel.text = friend.totalTime.secondsToStringTime()
                self.profileImageView.setImage(url: friend.profileImageURL)
            }
            .store(in: &cancellables)
        
        viewModel.seriesPublusher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] series in
                guard let self = self else { return }
                let xAxisValue = series.first?.weekdays.map { $0.dateToString(format: .day) }
                let labels = series.map { ChartLabel(title: $0.user, hexString: $0.hexString)}
                self.lineChartView.updateXAxisValue(values: xAxisValue)
                self.labelListView.addLabel(labels)
                series.forEach {
                    self.lineChartView.appendData(data: $0.studyTime, hexString: $0.hexString, name: $0.user)
                }
            }
            .store(in: &cancellables)
    }
}

private extension SocialDetailViewController {
    func setStudyLogStackView() {
        [dailyStudyLogLabel, weeklyStudyLogLabel, primaryCategoryDescriptionLabel].forEach {
            studyLogStackView.addArrangedSubview($0)
        }
    }
    
    func setStudyTimeStackView() {
        [dailyStudyTimeLabel, weeklyStudyTimeLabel, primaryCategoryLabel].forEach {
            studyTimeStackView.addArrangedSubview($0)
        }
    }
    
    func configureNavigationBar() {
        navigationItem.title = ComponentConstant.navigationTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
    }
}

private extension SocialDetailViewController {
    @objc func unfollowButtonDidTapped() {
        viewModel.didUnfollowFriend()
    }
    
    @objc func dismissButtonDidTapped() {
        viewModel.dismissButtonDidTapped()
    }
}
