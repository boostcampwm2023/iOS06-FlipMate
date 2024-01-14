//
//  ChartViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

import UIKit
import Combine

final class ChartViewController: BaseViewController {
    // MARK: - Constant
    private enum Constant {
        static let daily = NSLocalizedString("daily", comment: "")
        static let weekly = NSLocalizedString("weekly", comment: "")
    }
    
    // MARK: - Properties
    private let viewModel: ChartViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = ChartSegmentedControl(items: [Constant.daily, Constant.weekly])
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: FlipMateColor.gray2.color as Any,
            .font: FlipMateFont.mediumRegular.font], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label, 
            .font: FlipMateFont.mediumBold.font], for: .selected)
        segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var weeklyCalendarView: WeeklyCalendarView
    private var donutChartView = DonutChartView()
    private var weeklyChartView = UIView()
    
    var shouldHideDailyChartView: Bool? {
        didSet {
            guard let shouldHideDailyChartView = self.shouldHideDailyChartView else { return }
            donutChartView.isHidden = shouldHideDailyChartView
            weeklyChartView.isHidden = !donutChartView.isHidden
        }
    }
    
    // MARK: - init
    init(viewModel: ChartViewModelProtocol) {
        self.viewModel = viewModel
        self.weeklyCalendarView = WeeklyCalendarView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func configureUI() {
        [ segmentedControl, weeklyCalendarView, donutChartView ] .forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            segmentedControl.widthAnchor.constraint(equalToConstant: 180),
            
            weeklyCalendarView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            weeklyCalendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weeklyCalendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weeklyCalendarView.heightAnchor.constraint(equalToConstant: 150),
            
            donutChartView.topAnchor.constraint(equalTo: weeklyCalendarView.bottomAnchor, constant: 30),
            donutChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            donutChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            donutChartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
    override func bind() {
        viewModel.viewDidLoad()
        
        viewModel.dailyChartPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] studyLog in
                guard let self = self else { return }
                donutChartView.fetchStudyLog(studyLog)
            }
            .store(in: &cancellables)
    }
}

private extension ChartViewController {
    @objc func didChangeValue(segment: UISegmentedControl) {
        shouldHideDailyChartView = segment.selectedSegmentIndex != 0
    }
}
