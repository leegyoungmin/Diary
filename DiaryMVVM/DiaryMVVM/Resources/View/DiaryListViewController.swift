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
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Int, Diary>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpTableViewDataSource()
        
        bind()
    }
}

private extension DiaryListViewController {
    func bind() {
        viewModel.$diaries
            .sink { self.setSnapshot(with: $0) }
            .store(in: &cancellables)
    }
}

// MARK: - Configure TableView DataSource & Delegate
private extension DiaryListViewController {
    func setUpTableViewDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Diary>(
            tableView: tableView
        ) { table, indexPath, item in
            
            let cell = UITableViewCell()
            var content = cell.defaultContentConfiguration()
            
            content.text = item.title
            
            cell.contentConfiguration = content
            
            return cell
        }
    }
    
    func setSnapshot(with values: [Diary]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Diary>()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(values)
        dataSource?.apply(snapshot)
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
            print("Tapped present Button")
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: presentAction)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
