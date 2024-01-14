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
        label.text = "0"
        return label
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = nil
    }
    
    func updateDate(_ date: String) {
        dateLabel.text = date.toDate(.yyyyMMdd)?.dateToString(format: .day)
    }
    
    func updateBackgroundColor() {
        backgroundColor = isSelected ? FlipMateColor.gray3.color : .systemBackground
    }
}

private extension WeekCollectionViewCell {
    func configureUI() {
        [ dateLabel ] .forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
