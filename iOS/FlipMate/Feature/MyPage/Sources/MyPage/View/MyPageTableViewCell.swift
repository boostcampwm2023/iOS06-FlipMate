//
//  MyPageTableViewCell.swift
//
//
//  Created by 권승용 on 6/3/24.
//

import UIKit
import DesignSystem

final class MyPageTableViewCell: UITableViewCell {
    static let identifier = "MyPageTableViewCell"
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.textColor = .label
        label.text = "라벨 입니다"
        return label
    }()
    
    private let detail: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumRegular.font
        label.textColor = FlipMateColor.gray2.color
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("don't use storyboard")
    }
    
    private func configureUI() {
        let subviews = [
            title, detail
        ]
        
        subviews.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            detail.topAnchor.constraint(equalTo: title.topAnchor),
            detail.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            detail.bottomAnchor.constraint(equalTo: title.bottomAnchor)
        ])
    }
    
    func configureCell(title: String, detail: String?) {
        self.title.text = title
        self.detail.text = detail
    }
}
