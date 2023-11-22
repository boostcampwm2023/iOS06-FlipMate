//
//  CustomTextView.swift
//  FlipMate
//
//  Created by 신민규 on 11/22/23.
//

import UIKit

final class CustomTextView: UIView {
    private var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .systemBackground
        textView.font = FlipMateFont.smallRegular.font
        textView.contentInset = .init(top: 5, left: 10, bottom: 5, right: 10)
        
        return textView
    }()
    
    private(set) var placeholder: String? = nil
    private(set) var isShowPlaceholder: Bool = true
    
    init(placeholder: String){
        super.init(frame: .zero)
        self.placeholder = placeholder
        setupUI()
        showPlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    private func setupUI() {
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

extension CustomTextView: UITextViewDelegate {
    func showPlaceholder() {
        isShowPlaceholder = true
        textView.text = placeholder
        textView.textColor = FlipMateColor.gray3.color
    }
    
    func hidePlaceholder() {
        isShowPlaceholder = false
        textView.text = ""
        textView.textColor = .label
    }
    
    func text() -> String? {
        guard !isShowPlaceholder else { return nil }
        return textView.text
    }
    
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
