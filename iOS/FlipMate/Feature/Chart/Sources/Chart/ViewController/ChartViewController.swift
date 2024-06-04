//
//  ChartViewController.swift
//
//
//  Created by 권승용 on 6/2/24.
//

import Core
import UIKit
import Combine
import DesignSystem

public final class ChartViewController: BaseViewController {
    // MARK: - Constant
    private enum Constant {
        static let daily = NSLocalizedString("daily", comment: "")
        static let weekly = NSLocalizedString("weekly", comment: "")
        static let weeklyChart = NSLocalizedString("weeklyLearingChart", comment: "")
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var scrollContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var weeklyCalendarView: WeeklyCalendarView = {
        let calendarView = WeeklyCalendarView()
        calendarView.delegate = self
        return calendarView
    }()
    
    private lazy var donutChartView: CustomChartView = {
        let chartView = CustomChartView(frame: CGRect(
            x: .zero,
            y: .zero,
            width: view.frame.width,
            height: view.frame.width))
        chartView.layer.cornerRadius = 20
        chartView.layer.masksToBounds = true
        return chartView
    }()
    
    private lazy var weeklyChartLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.weeklyChart
        label.font = FlipMateFont.largeBold.font
        label.textColor = .label
        label.isHidden = true
        return label
    }()
    
    private lazy var barChartView: BarChartView = {
        let barChartView = BarChartView()
        barChartView.isHidden = true
        return barChartView
    }()
    
    private var shouldHideDailyChartView: Bool? {
        didSet {
            guard let shouldHideDailyChartView = self.shouldHideDailyChartView else { return }
            donutChartView.isHidden = shouldHideDailyChartView
            weeklyCalendarView.isHidden = shouldHideDailyChartView
            barChartView.isHidden = !shouldHideDailyChartView
            weeklyChartLabel.isHidden = !shouldHideDailyChartView
        }
    }
    
    // MARK: - init
    public init(viewModel: ChartViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func configureUI() {
        [ segmentedControl, scrollView ] .forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [ weeklyCalendarView, donutChartView, weeklyChartLabel, barChartView ] .forEach {
            scrollContentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.addSubview(scrollContentView)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            segmentedControl.widthAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weeklyCalendarView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            weeklyCalendarView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            weeklyCalendarView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            weeklyCalendarView.heightAnchor.constraint(equalToConstant: 150),
            
            donutChartView.topAnchor.constraint(equalTo: weeklyCalendarView.bottomAnchor, constant: 20),
            donutChartView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 15),
            donutChartView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -15),
            donutChartView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -80),
            
            weeklyChartLabel.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 15),
            weeklyChartLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 15),
            weeklyChartLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            
            barChartView.topAnchor.constraint(equalTo: weeklyChartLabel.bottomAnchor, constant: 40),
            barChartView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            barChartView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            barChartView.heightAnchor.constraint(equalTo: scrollContentView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    public override func bind() {
        viewModel.viewDidLoad()
        
        viewModel.dailyChartPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] studyLog in
                guard let self = self else { return }
                donutChartView.fetchLog(studyLog: studyLog)
            }
            .store(in: &cancellables)
        
        viewModel.weeklyChartPulisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dailyDatas in
                guard let self = self else { return }
                barChartView.fetchData(dailyDatas: dailyDatas)
            }
            .store(in: &cancellables)
    }
}

extension ChartViewController: WeeklyCalendarViewDelegate {
    func didSelectDate(_ date: Date) {
        FMLogger.chart.debug("해당 날짜가 선택되었습니다. \(date.dateToString(format: .yyyyMMdd))")
        viewModel.dateDidSelected(date: date)
    }
    
    func deSelectDate(_ date: Date) {
        FMLogger.chart.debug("해당 날짜가 선택 해제되었습니다. \(date.dateToString(format: .yyyyMMdd))")
    }
}

private extension ChartViewController {
    @objc func didChangeValue(segment: UISegmentedControl) {
        shouldHideDailyChartView = segment.selectedSegmentIndex != 0
    }
}
