//
//  CategoryListCollectionViewCell.swift
//  
//
//  Created by 임현규 on 6/16/24.
//

import UIKit
import DesignSystem

public final class CategoryListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private let categoryView: CategoryInfoView = {
        let view = CategoryInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    // MARK: - Public Methods
    public func updateShadow() {
        if isSelected {
            backgroundColor = FlipMateColor.gray2.color
            setShadow()
        } else {
            backgroundColor = .systemBackground
            layer.shadowOpacity = 0
        }
    }
    
    public func updateUI(_ subjectLabelText: String, _ circleBackgroundColor: UIColor?, _ timeLabelText: String?) {
        categoryView.updateUI(subjectLabelText, circleBackgroundColor, timeLabelText)
    }
}

// MARK: - Private Methods
private extension CategoryListCollectionViewCell {
    func configureUI() {
        [ categoryView ].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
