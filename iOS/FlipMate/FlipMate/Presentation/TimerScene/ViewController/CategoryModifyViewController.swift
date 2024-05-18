//
//  CategoryModifyViewController.swift
//  FlipMate
//
//  Created by 신민규 on 11/22/23.
//

import Core
import UIKit
import Combine
import DesignSystem

enum CategoryPurpose {
    case create
    case update
    
    var title: String {
        switch self {
        case .create: return NSLocalizedString("addCategory", comment: "")
        case .update: return NSLocalizedString("modifyCategory", comment: "")
        }
    }
}

final class CategoryModifyViewController: BaseViewController {
    private enum Constant {
        static let leftNavigationBarItemTitle = NSLocalizedString("close", comment: "")
        static let rightNavigationBarItemTitle = NSLocalizedString("done", comment: "")
        static let sectionNames: [String] = [NSLocalizedString("categoryName", comment: ""), NSLocalizedString("categoryColor", comment: "")]
        static let placeHolders: [String] = [NSLocalizedString("categoryNamePlaceHolder", comment: "")]
        static let categoryErrorTitle = NSLocalizedString("categoryErrorTitle", comment: "")
        static let yes = NSLocalizedString("yes", comment: "")
        static let categoryNameCountError = NSLocalizedString("categoryNameCountError", comment: "")
        static let categoryNameIsDuplicated = NSLocalizedString("categoryNameIsDuplicated", comment: "")
        static let unknownError = NSLocalizedString("unknownError", comment: "")
    }
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    private let viewModel: CategoryModifyViewModelProtocol
    private let purpose: CategoryPurpose
    
    init(viewModel: CategoryModifyViewModelProtocol, purpose: CategoryPurpose) {
        self.viewModel = viewModel
        self.purpose = purpose
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
    }
    
    override func bind() {
        viewModel.selectedCategoryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] category in
                guard let self = self, let category = category else { return }
                categoryTitleTextField.text = category.subject
                categoryColorSelectView.updateColor(color: category.color)
            }
            .store(in: &cancellables)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        guard let categoryTitle = categoryTitleTextField.text else {
            FMLogger.general.error("빈 제목, 추가할 수 없음")
            return
        }
        
        if categoryTitle.isEmpty || categoryTitle.count > 10 {
            showAlert(message: Constant.categoryNameCountError)
            return
        }
        
        let colorCode = categoryColorSelectView.colorValue()
        let name = categoryTitle
        
        Task {
            do {
                try await viewModel.performCategoryModification(purpose: purpose, name: name, colorCode: colorCode)
            } catch let categoryError as CategoryModificationError {
                switch categoryError {
                case .duplicatedName: showAlert(message: Constant.categoryNameIsDuplicated)
                case .unknownError: showAlert(message: Constant.unknownError)
                }
            }
        }
    }
}

// MARK: - Alert Function
private extension CategoryModifyViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: Constant.categoryErrorTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constant.yes, style: .default)
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
