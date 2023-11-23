//
//  CategorySettingFooterView.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/20.
//

import UIKit
import Combine

final class CategorySettingFooterView: UICollectionReusableView {
    // MARK: - Constant
    private enum Constant {
        static let addButtonTitle = "카테고리 추가 +"
        static let addButtonborderWidth: CGFloat = 1
        static let addButtoncornerRedius: CGFloat = 8
    }
    
    // MARK: - UI Components
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.addButtonTitle, for: .normal)
        button.setTitleColor(FlipMateColor.gray2.color, for: .normal)
        button.titleLabel?.font = FlipMateFont.mediumBold.font
        button.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        button.layer.borderWidth = Constant.addButtonborderWidth
        button.layer.cornerRadius = Constant.addButtoncornerRedius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(footerViewSelected))
    private var subject = PassthroughSubject<Void, Never>()
    var cancellable: AnyCancellable?
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
    }
    
    func tapPublisher() -> AnyPublisher<Void, Never> {
        return subject
            .eraseToAnyPublisher()
    }
}

// MARK: - UI Setting
private extension CategorySettingFooterView {
    func configureUI() {
        addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private extension CategorySettingFooterView {
    func configureGestureRecognizers() {
        print("tapgesture added")
        tapGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func footerViewSelected() {
        subject.send()
    }
}
