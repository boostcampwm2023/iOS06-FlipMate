//
//  CategoryListCollectionViewCell.swift
//  FlipMate
//
//  Created by 신민규 on 11/15/23.
//

import UIKit
import Combine

final class CategoryListCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryListCollectionViewCell"
    
    var cancellable: AnyCancellable?
    
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.textColor = UIColor.label
        label.text = "과목명"
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
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    func updateUI(category: Category) {
        subjectLabel.text = category.subject
        colorCircle.backgroundColor = UIColor(hexString: category.color)
        timeLabel.text = category.studyTime?.secondsToStringTime()
    }
    
    func updateShadow() {
        if isSelected {
            backgroundColor = FlipMateColor.gray2.color
            setShadow()
        } else {
            backgroundColor = .systemBackground
            layer.shadowOpacity = 0
        }
    }
    
    func setTimeLabelHidden(isHidden: Bool) {
        timeLabel.isHidden = isHidden
    }
}

private extension CategoryListCollectionViewCell {
    func configureUI() {
        [colorCircle, subjectLabel, timeLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            colorCircle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            colorCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorCircle.widthAnchor.constraint(equalToConstant: 24.0),
            colorCircle.heightAnchor.constraint(equalToConstant: 24.0)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 24.0),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 120.0),
            timeLabel.heightAnchor.constraint(equalToConstant: 24.0)
        ])
        
        NSLayoutConstraint.activate([
            subjectLabel.leadingAnchor.constraint(equalTo: colorCircle.trailingAnchor, constant: 24.0),
            subjectLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            subjectLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }
    
    func configureCell() {
        layer.borderWidth = 1.0
        layer.borderColor = FlipMateColor.gray2.color?.cgColor
        layer.cornerRadius = 8.0
    }
}

@available(iOS 17.0, *)
#Preview {
    CategoryListCollectionViewCell()
}
