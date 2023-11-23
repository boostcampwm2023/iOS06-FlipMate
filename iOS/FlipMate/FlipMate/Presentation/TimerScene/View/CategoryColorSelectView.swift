//
//  CategoryColorSelectView.swift
//  FlipMate
//
//  Created by 신민규 on 11/22/23.
//

import UIKit

final class CategoryColorSelectView: UIView {
    private var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.textColor = .label
        colorLabel.font = FlipMateFont.mediumRegular.font
        colorLabel.text = "# 000000"
        
        return colorLabel
    }()
    
    private var colorCircle: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
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

private extension CategoryColorSelectView {
    func configureUI() {
        addSubview(colorLabel)
        addSubview(colorCircle)
        self.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            colorCircle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            colorCircle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            colorCircle.widthAnchor.constraint(equalToConstant: 24.0),
            colorCircle.heightAnchor.constraint(equalToConstant: 24.0)
        ])
        
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            colorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

@available(iOS 17.0, *)
#Preview {
    CategoryColorSelectView()
}
