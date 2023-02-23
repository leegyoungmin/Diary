//
//  DiaryEditViewController.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import SnapKit
import Combine

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
    
    private let viewModel: DiaryEditViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DiaryEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        bind()
        bindAction()
    }
}

private extension DiaryEditViewController {
    func bind() {
        viewModel.$title
            .sink { [weak self] in self?.titleTextField.text = $0 }
            .store(in: &cancellables)
        
        viewModel.$body
            .sink { [weak self] in self?.bodyTextView.text = $0 }
            .store(in: &cancellables)
        
        viewModel.$date
            .sink { [weak self] in self?.navigationItem.title = $0 }
            .store(in: &cancellables)
    }
    
    func bindAction() {
        titleTextField.textChangePublisher
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.viewModel.title = $0
                self?.viewModel.saveData()
            }
            .store(in: &cancellables)
        
        bodyTextView.textChangePublisher
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.viewModel.body = $0
                self?.viewModel.saveData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Configure UI
private extension DiaryEditViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
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
}
