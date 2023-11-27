//
//  CategoryColorSelectView.swift
//  FlipMate
//
//  Created by 신민규 on 11/22/23.
//

import UIKit

final class CategoryColorSelectView: UIView {
    var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.textColor = .label
        colorLabel.font = FlipMateFont.mediumRegular.font
        colorLabel.text = "000000FF"
        
        return colorLabel
    }()
    
    private lazy var colorWell: UIColorWell = {
        let colorWell = UIColorWell()
        colorWell.translatesAutoresizingMaskIntoConstraints = false
        colorWell.addTarget(self, action: #selector(colorWellChanged(_:)), for: .valueChanged)
        return colorWell
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
        addSubview(colorWell)
        colorWell.selectedColor = .black
        self.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            colorWell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            colorWell.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            colorWell.widthAnchor.constraint(equalToConstant: 24.0),
            colorWell.heightAnchor.constraint(equalToConstant: 24.0)
        ])
        
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            colorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

// MARK: - objc function
private extension CategoryColorSelectView {
    @objc func colorWellChanged(_ sender: Any) {
        colorLabel.text = colorWell.selectedColor?.toHexString() }
}
@available(iOS 17.0, *)
#Preview {
    CategoryColorSelectView()
}
