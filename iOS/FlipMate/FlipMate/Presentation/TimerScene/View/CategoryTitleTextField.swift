//
//  CategoryTextField.swift
//  FlipMate
//
//  Created by 신민규 on 11/22/23.
//

import UIKit

final class CategoryTitleTextField: UITextField {
    private var textView: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemBackground
        textField.font = FlipMateFont.mediumRegular.font
        
        return textField
    }()
    
    private var isShowPlaceholder: Bool = true
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    private func configureUI() {
        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textView.leftAnchor.constraint(equalTo: self.leftAnchor),
            textView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}

extension CategoryTitleTextField {
    func text() -> String? {
        guard !isShowPlaceholder else { return nil }
        return textView.text
    }
    
    func setText(text: String) {
        textView.text = text
    }
}

@available(iOS 17.0, *)
#Preview {
    CategoryTitleTextField(placeholder: "HELLO")
}
