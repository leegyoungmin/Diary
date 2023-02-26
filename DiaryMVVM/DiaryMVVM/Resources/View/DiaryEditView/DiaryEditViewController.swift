//
//  DiaryEditViewController.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import SnapKit
import Combine

final class DiaryEditViewController: UIViewController {
    
    enum viewType {
        case create
        case edit
    }
    
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
    
    init(viewMode: viewType = .create, viewModel: DiaryEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        if viewMode == .edit {
            titleTextField.becomeFirstResponder()
        }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.saveData()
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
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] notification in
                self?.raiseUpBodyView(with: notification)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] notification in
                self?.pullDownBodyView(with: notification)
            }
            .store(in: &cancellables)
        
        viewModel.isShowMenuButton
            .sink {
                self.navigationItem.rightBarButtonItem?.isEnabled = $0
            }
            .store(in: &cancellables)
        
        viewModel.$isDismiss
            .filter { $0 }
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    func bindAction() {
        titleTextField.textChangePublisher
            .sink { [weak self] in
                self?.viewModel.title = $0
            }
            .store(in: &cancellables)
        
        bodyTextView.textChangePublisher
            .sink { [weak self] in
                self?.viewModel.body = $0
            }
            .store(in: &cancellables)
    }
}

private extension DiaryEditViewController {
    func presentAlertSheet() {
        view.endEditing(true)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "공유하기", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let shareText = self.viewModel.title + "\n" + self.viewModel.body
            let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            self.present(activityViewController, animated: true)
        }
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            self.viewModel.deleteData()
        }
        let cancelAction = UIAlertAction(title: "취소하기", style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach(alertController.addAction)
        present(alertController, animated: true)
    }
}

// MARK: - Configure UI
private extension DiaryEditViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
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
    
    func configureNavigationBar() {
        let presentAction = UIAction { _ in self.presentAlertSheet() }
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), primaryAction: presentAction)
        navigationItem.rightBarButtonItem = menuButton
    }
    
    func raiseUpBodyView(with notification: Notification) {
        if bodyTextView.isFirstResponder,
           let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           bodyTextView.contentInset.bottom == 0 {
            bodyTextView.contentInset.bottom = keyboardFrame.cgRectValue.height
        }
    }
    
    func pullDownBodyView(with notification: Notification) {
        bodyTextView.contentInset.bottom = 0
    }
}
