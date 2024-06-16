//
//  CategorySettingCollectionViewCell.swift
//
//
//  Created by 임현규 on 6/16/24.
//

import UIKit
import DesignSystem

public final class CategorySettingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    private let categoryView: CategoryInfoView = {
        let view = CategoryInfoView(isTimerLabelHidden: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureCategoryCellLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    public func updateUI(_ subjectLabelText: String, _ circleBackgroundColor: UIColor?, _ timeLabelText: String?) {
        categoryView.updateUI(subjectLabelText, circleBackgroundColor, timeLabelText)
    }
}

// MARK: - Private Methods
private extension CategorySettingCollectionViewCell {
    func configureUI() {
        [ categoryView ] .forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
