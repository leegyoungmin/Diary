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
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Int, Diary>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpTableViewDataSource()
        
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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

// MARK: - Configure TableView DataSource & Delegate
private extension DiaryListViewController {
    func setUpTableViewDataSource() {
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
        dataSource?.apply(snapshot, animatingDifferences: false)
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
