//
//  CategoryModifyViewController.swift
//  FlipMate
//
//  Created by 신민규 on 11/22/23.
//

import UIKit

final class CategoryModifyViewController: BaseViewController {
    private enum ConstantString {
        static let title = "카테고리 수정"
        static let leftNavigationBarItemTitle = "닫기"
        static let rightNavigationBarItemTitle = "완료"
        static let sectionNames: [String] = ["카테고리 명", "색상"]
        static let placeHolders: [String] = ["카테고리 이름을 입력해주세요", "색상을 선택해주세요"]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // MARK: UI Components
    private lazy var firstSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ConstantString.sectionNames.first
        label.font = FlipMateFont.mediumBold.font
        label.textColor = .label
        
        return label
    }()
    
    private lazy var categoryTitleTextView: CategoryTitleTextView = {
        let textView = CategoryTitleTextView(placeholder: ConstantString.placeHolders[0])
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 6
        return textView
    }()
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
    }
    
    // MARK: Configure UI
    override func configureUI() {
        view.backgroundColor = FlipMateColor.gray4.color
        let subViews = [firstSectionTitleLabel,
                        categoryTitleTextView
                        ]

        subViews.forEach {
                view.addSubview($0)
            }
        
        NSLayoutConstraint.activate([
            firstSectionTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            firstSectionTitleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 32)
        ])
        
        NSLayoutConstraint.activate([
            categoryTitleTextView.topAnchor.constraint(equalTo: firstSectionTitleLabel.bottomAnchor, constant: 20),
            categoryTitleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            categoryTitleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }
}

// MARK: Navigation Bar
private extension CategoryModifyViewController {
    func setUpNavigation() {
        navigationItem.title = ConstantString.title
        navigationItem.largeTitleDisplayMode = .never
        
        setupNavigationBarButton()
    }
    
    func setupNavigationBarButton() {
        let closeButton = UIBarButtonItem(title: ConstantString.leftNavigationBarItemTitle, style: .plain, target: self, action: #selector(closeButtonTapped))
        let doneButton = UIBarButtonItem(title: ConstantString.rightNavigationBarItemTitle, style: .done, target: self, action: #selector(doneButtonTapped))
    }
}

// MARK: objc function
private extension CategoryModifyViewController {
    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: 완료 버튼 눌렸을 때 동작
    }
}
//@available(iOS 17.0, *)
//#Preview {
//    CategoryModifyViewController()
//}
