//
//  WeekCollectionViewCell.swift
//  FlipMate
//
//  Created by 임현규 on 2024/01/07.
//

import UIKit

final class WeekCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Components
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.smallBold.font
        return label
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .red
        return view
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = nil
    }
    
    func updateDate(_ date: String) {
        dateLabel.text = date.toDate(.yyyyMMdd)?.dateToString(format: .day)
    }
    
    func showCircleView() {
        circleView.isHidden = false
    }
    
    func hideCircleView() {
        circleView.isHidden = true
    }
}

private extension WeekCollectionViewCell {
    func configureUI() {
        [ dateLabel, circleView ] .forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 30),
            circleView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        bringSubviewToFront(dateLabel)
    }
}
