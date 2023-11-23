//
//  CustomTextView.swift
//  FlipMate
//
//  Created by 신민규 on 11/22/23.
//

import UIKit

final class CategoryTitleTextView: UIView {
    private var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .systemBackground
        textView.font = FlipMateFont.mediumRegular.font
        textView.contentInset = .init(top: 5, left: 10, bottom: 5, right: 10)
        
        return textView
    }()
    
    private var placeholder: String?
    private var isShowPlaceholder: Bool = true
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        configureUI()
        showPlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    private func configureUI() {
        textView.delegate = self
        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textView.leftAnchor.constraint(equalTo: self.leftAnchor),
            textView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}

extension CategoryTitleTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isShowPlaceholder {
            hidePlaceholder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            showPlaceholder()
        }
    }
}

private extension CategoryTitleTextView {
    func showPlaceholder() {
        isShowPlaceholder = true
        textView.text = placeholder
        textView.textColor = FlipMateColor.gray2.color
    }
    
    func hidePlaceholder() {
        isShowPlaceholder = false
        textView.text = ""
        textView.textColor = .label
    }
}

extension CategoryTitleTextView {
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
    CategoryTitleTextView(placeholder: "HELLO")
}
