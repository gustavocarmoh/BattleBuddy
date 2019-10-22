//
//  SortableTableViewController.swift
//  BattleBuddy
//
//  Created by Mike on 8/4/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol SortableItemSelectionDelegate {
    func itemSelected(_ selection: Sortable)
    func selectionCancelled()
}

class SortableTableViewController: BaseTableViewController, SortableHeaderViewDelegate {
    let selectionDelegate: SortableItemSelectionDelegate
    let config: SortConfiguration
    var currentSelection: Sortable?
    lazy var header: SortableHeaderView = { SortableHeaderView(delegate: self, params: config.params, initialSort: config.defaultSortParam) }()
    var presentedModally = true
    var searchText: String? {
        didSet {
            tableView.reloadData()
        }
    }
    var searchResults: [Sortable]?
    var items: [Sortable] { get { return searchResults ?? config.items } }

    required init?(coder: NSCoder) { fatalError() }

    init(selectionDelegate: SortableItemSelectionDelegate, config: SortConfiguration, currentSelection: Sortable?) {
        self.selectionDelegate = selectionDelegate
        self.config = config
        self.currentSelection = currentSelection

        super.init(style: .plain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = config.sortTitle

        if presentedModally {
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        }

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.tableFooterView = UIView()
    }

    @objc func handleCancel() {
        self.selectionDelegate.selectionCancelled()
    }

    func toggleSort(param: SortableParam) {
        config.toggleStateForParam(param)

        if !items.isEmpty {
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: - Table view data source
extension SortableTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? config.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortableTableViewCell.reuseId) ?? SortableTableViewCell(config: config)
        guard let sortableCell = cell as? SortableTableViewCell else { fatalError() }
        let item = items[indexPath.row]
        sortableCell.item = item
        sortableCell.isSelected = (item.sortId == currentSelection?.sortId)
        return sortableCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        selectionDelegate.itemSelected(config.items[indexPath.row])
    }
}
