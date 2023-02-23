//
//  ViewController.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.
        
import Combine
import SnapKit
import UIKit

final class DiaryListViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: DiaryListViewModel = DiaryListViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Int, Diary>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpTableViewDataSource()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchData()
    }
}

private extension DiaryListViewController {
    func bind() {
        viewModel.$diaries
            .sink { self.setSnapshot(with: $0) }
            .store(in: &cancellables)
    }
}

// MARK: - Configure TableView Delegate
extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let diary = viewModel.diaries[indexPath.row]
        let viewModel = DiaryEditViewModel(
            diary: diary,
            coreDataRepository: viewModel.coreDataRepository
        )
        let editViewController = DiaryEditViewController(viewMode: .edit, viewModel: viewModel)
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, view, completion in
            guard let result = self?.viewModel.deleteDiary(index: indexPath.row) else {
                completion(false)
                return
            }
            completion(result)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let shareAction = UIContextualAction(style: .normal, title: nil) { _, view, completion in
            let diary = self.viewModel.diaries[indexPath.row]
            let shareText = (diary.title + "\n" + diary.body)
            
            let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true)
            completion(true)
        }
        shareAction.image = UIImage(systemName: "icloud.and.arrow.up.fill")
        shareAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

// MARK: - Configure TableView DataSource & Snapshot
private extension DiaryListViewController {
    func setUpTableViewDataSource() {
        tableView.delegate = self
        dataSource = UITableViewDiffableDataSource<Int, Diary>(
            tableView: tableView
        ) { table, indexPath, item in
            
            guard let cell = table.dequeueReusableCell(
                withIdentifier: DiaryListCell.identifier
            ) as? DiaryListCell else {
                return UITableViewCell()
            }
            
            cell.setDiary(with: item)
            
            return cell
        }
    }
    
    func setSnapshot(with values: [Diary]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Diary>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(values)
        dataSource?.apply(snapshot)
        
        print(snapshot.itemIdentifiers)
    }
}

// MARK: - Configure UI
private extension DiaryListViewController {
    func configureUI() {
        setNavigationBar()
        addChildComponents()
        setUpLayout()
    }
    
    func addChildComponents() {
        [tableView].forEach(view.addSubview)
    }
    
    func setUpLayout() {
        tableView.snp.makeConstraints {
            let safeArea = view.safeAreaLayoutGuide.snp
            $0.top.equalTo(safeArea.top)
            $0.leading.equalTo(safeArea.leading)
            $0.trailing.equalTo(safeArea.trailing)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "일기장"
        let presentAction = UIAction { _ in
            let viewModel = DiaryEditViewModel(coreDataRepository: self.viewModel.coreDataRepository)
            let controller = DiaryEditViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: presentAction)
    }
}
