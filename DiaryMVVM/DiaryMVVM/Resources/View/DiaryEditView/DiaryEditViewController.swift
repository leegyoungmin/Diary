//
//  DiaryEditViewController.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import SnapKit

final class DiaryEditViewController: UIViewController {
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .title1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제목을 입력하세요."
        return textField
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainer.lineFragmentPadding = .zero
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: - Configure UI
private extension DiaryEditViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigation()
        addChildComponents()
        setUpLayout()
    }
    
    func addChildComponents() {
        [titleTextField, bodyTextView].forEach(view.addSubview)
    }
    
    func setUpLayout() {
        titleTextField.snp.makeConstraints {
            $0.leading.equalTo(view.readableContentGuide.snp.leading)
            $0.trailing.equalTo(view.readableContentGuide.snp.trailing)
            $0.top.equalTo(view.readableContentGuide.snp.top).offset(8)
        }
        
        bodyTextView.snp.makeConstraints {
            $0.leading.equalTo(titleTextField.snp.leading)
            $0.top.equalTo(titleTextField.snp.bottom)
            $0.trailing.equalTo(titleTextField.snp.trailing)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureNavigation() {
        navigationItem.title = Date().description
    }
}