//
//  BaseTableViewController.swift
//  Moments
//
//  Created by wjw on 2025/5/28.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import DesignKit

class BaseTableViewController: BaseViewController {
    var viewModel: ListViewModel!
    
    private let tableView: UITableView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = UIColor.designKit.background
    }
    
    private let activityIndicatorView: UIActivityIndicatorView = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let errorLable: UILabel = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
        $0.textColor = UIColor.designKit.primaryText
        $0.text = L10n.MomentsList.errorMessage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        DispatchQueue.main.async {
            //walk around for a warning
                // https://github.com/RxSwiftCommunity/RxDataSources/issues/331
            self.setupBindings()
        }
        
        loadItems()
    }
    
    var tableViewCellsToRegister: [String: UITableViewCell.Type] {
        fatalError(L10n.Development.fatalErrorSubclassToImplement)
    }
}

private extension BaseTableViewController {
    func setupUI() {
        view.backgroundColor = UIColor.designKit.background
        
        tableViewCellsToRegister.forEach {
            tableView.register($0.value, forCellReuseIdentifier: $0.key)
        }
        [tableView, activityIndicatorView, errorLable].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        errorLable.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupBindings() {
        tableView.refreshControl = configure(UIRefreshControl()) {
            let refreshControl = $0
            $0.rx.controlEvent(.valueChanged)
                .filter{ refreshControl.isRefreshing }
                .bind { [weak self] _ in self?.viewModel.loadItems() }
                .disposed(by: disposeBag)
        }
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ListItemViewModel> > { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: item)), for: indexPath)
            (cell as? ListItemCell)?.update(with: item)
            return cell
        }
        
        viewModel.listItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.hasError
            .map { !$0 }
            .bind(to: errorLable.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func loadItems() {
        viewModel.hasError.onNext(false)
        viewModel.loadItems()
            .observeOn(MainScheduler.instance)
            .do(onDispose: {[weak self] in
                self?.activityIndicatorView.rx.isAnimating.onNext(false)
                self?.tableView.refreshControl?.endRefreshing()
            })
            .map { false }
            .startWith(true)
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
