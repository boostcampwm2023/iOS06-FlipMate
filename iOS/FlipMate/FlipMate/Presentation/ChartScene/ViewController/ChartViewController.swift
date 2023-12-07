//
//  ChartViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

import UIKit
import SwiftUI

final class ChartViewController: BaseViewController {
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = ChartSegmentedControl(items: ["일간", "주간"])
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: FlipMateColor.gray2.color as Any, 
            .font: FlipMateFont.mediumRegular.font], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label, 
            .font: FlipMateFont.mediumBold.font], for: .selected)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private var dailyChartView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private var weeklyChartView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    var shouldHideDailyChartView: Bool? {
        didSet {
            guard let shouldHideDailyChartView = self.shouldHideDailyChartView else { return }
            dailyChartView.isHidden = shouldHideDailyChartView
            weeklyChartView.isHidden = !dailyChartView.isHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSegmentControll()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func configureUI() {
        super.configureUI()
        setDailyChart()
        setWeeklyChart()
        
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.dailyChartView)
        self.view.addSubview(self.weeklyChartView)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            segmentedControl.widthAnchor.constraint(equalToConstant: 140)
        ])
        NSLayoutConstraint.activate([
            dailyChartView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 30),
            dailyChartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            dailyChartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            dailyChartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
        NSLayoutConstraint.activate([
            weeklyChartView.topAnchor.constraint(equalTo: dailyChartView.topAnchor),
            weeklyChartView.leadingAnchor.constraint(equalTo: dailyChartView.leadingAnchor),
            weeklyChartView.trailingAnchor.constraint(equalTo: dailyChartView.trailingAnchor),
            weeklyChartView.bottomAnchor.constraint(equalTo: dailyChartView.bottomAnchor)
        ])
    }
}

private extension ChartViewController {
    func setSegmentControll() {
        segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        self.didChangeValue(segment: self.segmentedControl)
    }
    
    func setDailyChart() {
        let dailyChartView = DailyChartView(
            viewModel: ChartViewModel(
                chartUseCase: DefaultChartUseCase(
                    repository: DefaultChartRepository(
                        provider: Provider(
                            urlSession: URLSession.shared))),
                actions: nil))
        let hostingController = UIHostingController(rootView: dailyChartView)
        addChild(hostingController)
        guard let newChartView = hostingController.view else { return }
        self.dailyChartView = newChartView
        self.view.addSubview(newChartView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.didMove(toParent: self)
    }
    
    func setWeeklyChart() {
        let weeklyChartView = WeeklyChartView(
            viewModel: ChartViewModel(
                chartUseCase: DefaultChartUseCase(
                    repository: DefaultChartRepository(
                        provider: Provider(urlSession: URLSession.shared))),
                actions: nil))
        let hostingController = UIHostingController(rootView: weeklyChartView)
        addChild(hostingController)
        guard let newChartView = hostingController.view else { return }
        self.weeklyChartView = newChartView
        self.view.addSubview(newChartView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.didMove(toParent: self)
    }
}

private extension ChartViewController {
    @objc func didChangeValue(segment: UISegmentedControl) {
        shouldHideDailyChartView = segment.selectedSegmentIndex != 0
    }
}

@available(iOS 17.0, *)
#Preview {
    ChartViewController()
}
