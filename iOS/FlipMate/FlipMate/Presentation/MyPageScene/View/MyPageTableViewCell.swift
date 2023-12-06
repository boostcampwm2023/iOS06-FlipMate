//
//  File.swift
//  FlipMate
//
//  Created by 권승용 on 12/5/23.
//

import UIKit

final class MyPageTableViewCell: UITableViewCell {
    static let identifier = "MyPageTableViewCell"
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.mediumBold.font
        label.textColor = .label
        label.text = "라벨 입니다"
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
            title
        ]
        
        subviews.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    func configureCell(title: String) {
        self.title.text = title
    }
}
