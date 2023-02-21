//
//  ViewController.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.
        
import SnapKit
import UIKit

final class DiaryListViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Int, Int>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

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
