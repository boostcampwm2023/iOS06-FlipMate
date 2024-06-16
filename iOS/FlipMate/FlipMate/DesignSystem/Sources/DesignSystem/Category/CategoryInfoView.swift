//
//  CategoryInfoView.swift
//
//
//  Created by 임현규 on 6/16/24.
//

import UIKit

public final class CategoryInfoView: UIView {
    
    // MARK: - UI Components
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.textColor = UIColor.label
        label.text = Constants.subject
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.textColor = UIColor.label
        return label
    }()
    
    private let colorCircle: UIView = {
        let view = UIView()
        view.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        view.layer.borderWidth = Constants.layerWidth
        view.layer.cornerRadius = Constants.circleLayerRadius
        return view
    }()
    
    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayer()
    }
    
    public init(isTimerLabelHidden: Bool) {
        super.init(frame: .zero)
        timeLabel.isHidden = isTimerLabelHidden
        configureUI()
        configureLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    // MARK: - Public Methods
    public func updateUI(_ subjectLabelText: String, _ circleBackgroundColor: UIColor?, _ timeLabelText: String?) {
        subjectLabel.text = subjectLabelText
        colorCircle.backgroundColor = circleBackgroundColor
        timeLabel.text = timeLabelText
    }
}

// MARK: - Private Methods
private extension CategoryInfoView {
    func configureUI() {
        [colorCircle, subjectLabel, timeLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            colorCircle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leftMargin),
            colorCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorCircle.widthAnchor.constraint(equalToConstant: Constants.circleDiameter),
            colorCircle.heightAnchor.constraint(equalToConstant: Constants.circleDiameter)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.rightMargin),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: Constants.timerLabelWidth),
            timeLabel.heightAnchor.constraint(equalToConstant: Constants.heigth)
        ])
        
        NSLayoutConstraint.activate([
            subjectLabel.leadingAnchor.constraint(equalTo: colorCircle.trailingAnchor, constant: Constants.leftMargin),
            subjectLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            subjectLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeLabel.heightAnchor.constraint(equalToConstant: Constants.heigth)
        ])
    }
    
    func configureLayer() {
        layer.borderWidth = Constants.layerWidth
        layer.cornerRadius = Constants.viewLayerRadius
        layer.borderColor = FlipMateColor.gray2.color?.cgColor
    }
}

private extension CategoryInfoView {
    enum Constants {
        static let subject = "과목명"
        static let leftMargin: CGFloat = 24
        static let rightMargin: CGFloat = 24
        static let circleDiameter: CGFloat = 24
        static let heigth: CGFloat = 24
        static let timerLabelWidth: CGFloat = 120
        static let layerWidth: CGFloat = 1
        static let circleLayerRadius: CGFloat = 12
        static let viewLayerRadius: CGFloat = 8
    }
}
