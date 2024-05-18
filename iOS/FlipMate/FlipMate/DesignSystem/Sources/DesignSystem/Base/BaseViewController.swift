//
//  BaseViewController.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/13.
//

import UIKit

open class BaseViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureUI()
        bind()
    }
    
    /// 해당 메소드 내부에 UI Components 레이아웃을 작성해주세요
    open func configureUI() {
        
    }
    
    /// 해당 메소드 내부에 Combine bind 관련 로직을 작성해주세요.
    open func bind() {
        
    }
}
