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
    
    private lazy var categoryTitleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 6
        textField.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        textField.layer.borderWidth = 1
        textField.clearButtonMode = .always
        
        return textField
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
    private let purpose: CategoryPurpose
    private let category: Category?
    
    init(viewModel: CategoryViewModelProtocol, purpose: CategoryPurpose, category: Category? = nil) {
        self.viewModel = viewModel
        self.purpose = purpose
        self.category = category
        super.init(nibName: nil, bundle: nil)
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
        
        categoryTitleTextField.placeholder = Constant.placeHolders[0]
        categoryTitleTextField.addLeftPadding(width: 15)
        
        let subViews = [
            firstSectionTitleLabel,
            categoryTitleTextField,
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
            categoryTitleTextField.topAnchor.constraint(
                equalTo: firstSectionTitleLabel.bottomAnchor, constant: 12),
            categoryTitleTextField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            categoryTitleTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            categoryTitleTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            secondSectionTitleLabel.topAnchor.constraint(
                equalTo: categoryTitleTextField.bottomAnchor, constant: 60),
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
                equalTo: categoryTitleTextField.heightAnchor)
        ])
        
        if purpose == .update {
            guard let category = category else {
                FMLogger.general.error("가져온 카테고리 없음 에러")
                return
            }
            setText(text: category.subject)
        }
    }
}
// MARK: UITextFieldDelegate
extension CategoryModifyViewController: UITextFieldDelegate {
    func setText(text: String) {
        categoryTitleTextField.text = text
    }
}
// MARK: Navigation Bar
private extension CategoryModifyViewController {
    func setUpNavigation() {
        title = purpose.title
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
        viewModel.modifyCloseButtonTapped()
    }
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        if purpose == .create {
            Task {
                do {
                    guard let categoryTitle = categoryTitleTextField.text else {
                        FMLogger.general.error("빈 제목, 추가할 수 없음")
                        return
                    }
                    try await viewModel.createCategory(name: categoryTitle,
                                                       colorCode: categoryColorSelectView.colorLabel.text 
                                                       ?? "000000FF")
                } catch let error {
                    FMLogger.general.error("카테고리 추가 중 에러 \(error)")
                }
            }
        } else {
            Task {
                do {
                    guard let categoryTitle = categoryTitleTextField.text else {
                        FMLogger.general.error("빈 제목, 추가할 수 없음")
                        return
                    }
                    guard let category = category else {
                        FMLogger.general.error("가져온 카테고리 없음 에러")
                        return
                    }
                    try await viewModel.updateCategory(of: category.id, 
                                                       newName: categoryTitle,
                                                       newColorCode: categoryColorSelectView.colorLabel.text 
                                                       ?? "000000FF",
                                                       studyTime: category.studyTime)
                } catch let error {
                    FMLogger.general.error("카테고리 추가 중 에러 \(error)")
                }
            }
        }
        viewModel.modifyDoneButtonTapped()
    }
}
