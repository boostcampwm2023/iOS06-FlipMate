//
//  LabelView.swift
//
//
//  Created by 권승용 on 6/2/24.
//

import UIKit
import DesignSystem

struct ChartLabel {
    let title: String
    let hexString: String
}

final class LabelView: UIView {
    // MARK: - Properties
    private(set) var widthSize: CGFloat = 0.0
    
    // MARK: - UI Components
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.smallRegular.font
        label.textColor = .label
        return label
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use Storyboard")
    }
    
    func updateLabel(label: ChartLabel) {
        labelTitle.text = label.title
        colorView.backgroundColor = UIColor(hexString: label.hexString)
        labelTitle.sizeToFit()
        widthSize = Constant.colorViewSize + Constant.leading + labelTitle.frame.width
    }
}

extension LabelView {
    func configureUI() {
        [ labelTitle, colorView ] .forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.leading),
            colorView.widthAnchor.constraint(equalToConstant: Constant.colorViewSize),
            colorView.heightAnchor.constraint(equalToConstant: Constant.colorViewSize),
            
            labelTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: Constant.leading)
        ])
    }
}

extension LabelView {
    private enum Constant {
        static let leading: CGFloat = 5
        static let colorViewSize: CGFloat = 10
    }
}
