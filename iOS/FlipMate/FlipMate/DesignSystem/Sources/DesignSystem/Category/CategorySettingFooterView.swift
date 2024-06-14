//
//  CategorySettingFooterView.swift
//
//
//  Created by 권승용 on 5/30/24.
//

import UIKit
import Combine

public final class CategorySettingFooterView: UICollectionReusableView {
    // MARK: - Constant
    private enum Constant {
        static let addButtonTitle = NSLocalizedString("addCategory", comment: "")
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
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var subject = PassthroughSubject<Void, Never>()
    public var cancellable: AnyCancellable?
    
    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
    }
    
    public func tapPublisher() -> AnyPublisher<Void, Never> {
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
            addButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
}

private extension CategorySettingFooterView {
    @objc
    func addButtonTapped() {
        subject.send()
    }
}
