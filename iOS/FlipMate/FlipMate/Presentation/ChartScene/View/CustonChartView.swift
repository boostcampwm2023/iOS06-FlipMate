//
//  CustonChartView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/01/27.
//

import UIKit

final class CustomChartView: UIView {
    // MARK: - UI Components
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 20
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    private lazy var labelListView: LabelListView = {
        let view = LabelListView()
        view.backgroundColor = FlipMateColor.gray2.color
        return view
    }()
    
    private let donutChartView: DonutChartView = {
        let view = DonutChartView()
        view.backgroundColor = FlipMateColor.gray2.color
        return view
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use Storyboard")
    }
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        configureUI()
    }
    
    // MARK: - Methdos
    func fetchLog(studyLog: StudyLog) {
        donutChartView.fetchStudyLog(studyLog)
        fetchLabelList(studyLog: studyLog)
    }
}

// MARK: - Private Methods
private extension CustomChartView {
    func configureUI() {
        [ donutChartView, labelListView ] .forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            donutChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            donutChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            donutChartView.heightAnchor.constraint(equalToConstant: frame.width),
            
            labelListView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelListView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func fetchLabelList(studyLog: StudyLog) {
        labelListView.removeAllLabel()
        if studyLog.totalTime == 0 { return }
        let labels = studyLog.category
            .filter { $0.studyTime != 0 }
            .map { ChartLabel(title: $0.subject, hexString: $0.color) }
        labelListView.addLabel(labels)
    }
}

// MARK: - Constants
extension CustomChartView {
    private enum Constants {
        static let spacingX: CGFloat = 10
        static let spacingY: CGFloat = 25
        static let defaultPositionX: CGFloat = 10
        static let defaultPositionY: CGFloat = 0
        static let labelViewHegith: CGFloat = 20
    }
}
