//
//  TimerViewController.swift
//  FlipMate
//
//  Created by 권승용 on 11/13/23.
//

import UIKit

final class TimerViewController: BaseViewController {
    
    /// 오늘 학습한 총 시간 타이머
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        return label
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .gray
        return divider
    }()
    
    private lazy var categoryInstructionBlock: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "관리 버튼을 눌러\n카테고리를 설정해주세요"
        label.numberOfLines = 2
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    private lazy var categoryManageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.setTitle("관리", for: .normal)
        button.setTitleColor(FlipMateColor.gray1.color, for: .normal)
        button.tintColor = FlipMateColor.gray1.color
        return button
    }()
    
    private lazy var instructionImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .instruction)
        return image
    }()
    
    
    // MARK: - setup UI
    override func configureUI() {
        let subViews = [timerLabel,
                        divider,
                        categoryInstructionBlock,
                        categoryManageButton,
                        instructionImage
                        ]
        
        subViews.forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 30),
            divider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        NSLayoutConstraint.activate([
            categoryInstructionBlock.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 30),
            categoryInstructionBlock.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryInstructionBlock.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            categoryManageButton.topAnchor.constraint(equalTo: categoryInstructionBlock.bottomAnchor, constant: 10),
            categoryManageButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryManageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            
        ])
        
        NSLayoutConstraint.activate([
            instructionImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            instructionImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

@available(iOS 17.0, *)
#Preview {
    TimerViewController()
}
