//
//  CategoryListCollectionViewCell.swift
//  FlipMate
//
//  Created by 신민규 on 11/15/23.
//

import UIKit
import Combine

final class CategoryListCollectionViewCell: UICollectionViewCell {
    static let cellID = "CategoryListCollectionViewCell"
    
    var cancellable: AnyCancellable?
    
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.textColor = UIColor.black
        label.text = "과목명"
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.textColor = UIColor.black
        label.text = "00:00:00"
        return label
    }()
    
    private let colorCircle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
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
    
}

@available(iOS 17.0, *)
#Preview {
    CategoryListCollectionViewCell()
}

