//
//  TimerFinishViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/27.
//

import UIKit

final class TimerFinishViewController: BaseViewController {
    private enum Constant {
        static let save = "예"
        static let cancle = "아니요"
        static let title = "타이머 종료"
        static let learningTitle = "공부한 시간을 저장하시겠습니까?"
        static let learningTime = "00:00:00"
    }
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = FlipMateColor.gray2.color
        view.layer.opacity = 0.4
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var finishView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.save, for: .normal)
        button.backgroundColor = FlipMateColor.darkBlue.color
        button.titleLabel?.font = FlipMateFont.mediumBold.font
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var cancleButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.cancle, for: .normal)
        button.backgroundColor = FlipMateColor.darkBlue.color
        button.titleLabel?.font = FlipMateFont.mediumBold.font
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = FlipMateColor.gray2.color?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.title
        label.font = FlipMateFont.smallBold.font
        label.textColor = FlipMateColor.gray2.color
        return label
    }()
    
    private let learningTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.learningTitle
        label.font = FlipMateFont.mediumBold.font
        label.textColor = .label
        return label
    }()
    
    private let learningTimeContentLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.learningTime
        label.font = FlipMateFont.largeBold.font
        label.textColor = .label
        return label
    }()
    
    // MARK: - Life Cycle
    override func configureUI() {
        [backgroundView, finishView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [saveButton, cancleButton, titleLabel, learningTimeTitleLabel, learningTimeContentLabel].forEach {
            finishView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            finishView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            finishView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.centerXAnchor.constraint(equalTo: finishView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: finishView.topAnchor, constant: 10),
            
            learningTimeTitleLabel.centerXAnchor.constraint(equalTo: finishView.centerXAnchor),
            learningTimeTitleLabel.bottomAnchor.constraint(
                equalTo: learningTimeContentLabel.topAnchor,
                constant: -5),
            
            learningTimeContentLabel.centerXAnchor.constraint(equalTo: finishView.centerXAnchor),
            learningTimeContentLabel.centerYAnchor.constraint(equalTo: finishView.centerYAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: finishView.bottomAnchor),
            saveButton.leadingAnchor.constraint(equalTo: finishView.leadingAnchor),
            saveButton.widthAnchor.constraint(equalTo: finishView.widthAnchor, multiplier: 0.5),
            saveButton.heightAnchor.constraint(equalTo: finishView.heightAnchor, multiplier: 0.2),
            
            cancleButton.bottomAnchor.constraint(equalTo: finishView.bottomAnchor),
            cancleButton.trailingAnchor.constraint(equalTo: finishView.trailingAnchor),
            cancleButton.widthAnchor.constraint(equalTo: finishView.widthAnchor, multiplier: 0.5),
            cancleButton.heightAnchor.constraint(equalTo: finishView.heightAnchor, multiplier: 0.2)
        ])
    }
}

@available(iOS 17.0, *)
#Preview {
    TimerFinishViewController()
}
