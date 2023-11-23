//
//  CategoryModifyViewController.swift
//  FlipMate
//
//  Created by 신민규 on 11/22/23.
//

import UIKit

enum CategoryPurpose {
    case create
    case update
    
    var title: String {
        switch self {
        case .create: return "카테고리 추가"
        case .update: return "카테고리 수정"
        }
    }
}

final class CategoryModifyViewController: BaseViewController {
    private enum Constant {
        static let leftNavigationBarItemTitle = "닫기"
        static let rightNavigationBarItemTitle = "완료"
        static let sectionNames: [String] = ["카테고리 이름", "카테고리 색상"]
        static let placeHolders: [String] = ["이름을 입력해주세요", "색상을 선택해주세요"]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: UI Components
    private lazy var firstSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constant.sectionNames.first
        label.font = FlipMateFont.mediumBold.font
        label.textColor = .label
        
        return label
    }()
    
    private lazy var secondSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constant.sectionNames.last
        label.font = FlipMateFont.mediumBold.font
        label.textColor = .label
        
        return label
    }()
    
    private lazy var categoryTitleTextView: CategoryTitleTextView = {
        let textView = CategoryTitleTextView(placeholder: Constant.placeHolders[0])
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 6
        textView.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        textView.layer.borderWidth = 1
        
        return textView
    }()
    
    private lazy var categoryColorSelectView: CategoryColorSelectView = {
        let colorView = CategoryColorSelectView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 6
        colorView.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        colorView.layer.borderWidth = 1
        
        return colorView
    }()
    
    private let viewModel: CategoryViewModelProtocol
    
    init(title: String, viewModel: CategoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
    }
    
    // MARK: Configure UI
    override func configureUI() {
        view.backgroundColor = .systemBackground
        
        let subViews = [
            firstSectionTitleLabel,
            categoryTitleTextView,
            secondSectionTitleLabel,
            categoryColorSelectView
        ]
        
        subViews.forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            firstSectionTitleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            firstSectionTitleLabel.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 32)
        ])
        
        NSLayoutConstraint.activate([
            categoryTitleTextView.topAnchor.constraint(
                equalTo: firstSectionTitleLabel.bottomAnchor, constant: 12),
            categoryTitleTextView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            categoryTitleTextView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            secondSectionTitleLabel.topAnchor.constraint(
                equalTo: categoryTitleTextView.bottomAnchor, constant: 60),
            secondSectionTitleLabel.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 32)
        ])
        
        NSLayoutConstraint.activate([
            categoryColorSelectView.topAnchor.constraint(
                equalTo: secondSectionTitleLabel.bottomAnchor, constant: 12),
            categoryColorSelectView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            categoryColorSelectView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            categoryColorSelectView.heightAnchor.constraint(
                equalTo: categoryTitleTextView.heightAnchor)
        ])
    }
}

// MARK: Navigation Bar
private extension CategoryModifyViewController {
    func setUpNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        setupNavigationBarButton()
    }
    
    func setupNavigationBarButton() {
        let closeButton = UIBarButtonItem(
            title: Constant.leftNavigationBarItemTitle,
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped))
        let doneButton = UIBarButtonItem(
            title: Constant.rightNavigationBarItemTitle,
            style: .done,
            target: self,
            action: #selector(doneButtonTapped))

        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
    }
}

// MARK: objc function
private extension CategoryModifyViewController {
    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: 색깔 선택 기능 미구현
        if title == "카테고리 추가" {
            Task {
                do {
                    guard let categoryTitle = categoryTitleTextView.text() else {
                        FMLogger.general.error("빈 제목, 추가할 수 없음")
                        return
                    }
                    try await viewModel.createCategory(name: categoryTitle, colorCode: "FFFFFFFF")
                    dismiss(animated: true)
                } catch let error {
                    FMLogger.general.error("카테고리 추가 중 에러 \(error)")
                }
            }
        }
    }
}
