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
        return stackView
    }()
    
    private lazy var labelListView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let donutChartView = DonutChartView()
    
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

        labelListView.backgroundColor = .systemBackground
        
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
        labelListView.subviews.forEach { $0.removeFromSuperview() }
        if studyLog.totalTime == 0 { return }
        
        var count: CGFloat = 1.0
        var positionX = Constants.defaultPositionX
        var positionY = Constants.defaultPositionY
        let spacingX = Constants.spacingX
        let spacingY = Constants.spacingY
        
        studyLog.category.forEach { category in
            if category.studyTime == 0 { return }
            let labelView = LabelView()
            let chartLabel = ChartLabel(title: category.subject, hexString: category.color)
            labelView.updateLabel(label: chartLabel)
            
            if frame.width - positionX < labelView.widthSize {
                positionX = Constants.defaultPositionX
                positionY += spacingY
                count += 1
            }
            
            labelView.frame = CGRect(x: positionX, y: positionY, width: labelView.widthSize, height: Constants.labelViewHegith)
            labelListView.addSubview(labelView)
            positionX += labelView.widthSize + spacingX
        }
        
        labelListView.heightAnchor.constraint(equalToConstant: count * spacingY).isActive = true
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
