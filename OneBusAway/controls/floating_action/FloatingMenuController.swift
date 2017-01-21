//
//  FloatingMenuController.swift
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 1/19/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

import SnapKit
import UIKit

@objc protocol FloatingMenuDataSource {
    func rowsFor(_ floatingMenu: FloatingMenuController) -> [FloatingMenuAction]?
}

class FloatingMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var actions: [FloatingMenuAction] = []

    public weak var dataSource: FloatingMenuDataSource?

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView.init()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()

    private var floatingActionButton: FloatingButton = {
        let button = FloatingButton.init(frame: CGRect.zero)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeMenu), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)

        self.view.addSubview(self.floatingActionButton)
        self.view.addSubview(self.tableView)

        self.floatingActionButton.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self.view).inset(20)
            make.bottom.equalTo(self.view).inset(60)
        }

        self.tableView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.floatingActionButton.snp.top).offset(OBATheme.defaultPadding())
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }

        self.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateContentInset()
    }


    // MARK: - Display

    func closeMenu() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Data Loading

    public func reloadData() {
        self.actions = self.dataSource?.rowsFor(self) ?? []
        self.tableView.reloadData()
    }

    // MARK: - UITableView

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier")

        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "identifier")
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.textAlignment = .right
        }

        let action = self.actions[indexPath.row]

        cell?.textLabel?.text = action.text

        return cell!
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuAction = self.actions[indexPath.row]

        guard let target = menuAction.target, let action = menuAction.action else {
            return
        }

        _ = target.perform(action, with: self)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func updateContentInset() {
        let height = self.tableView.bounds.height
        let contentSize = self.tableView.contentSize.height
        let maxTop = max(0.0, height - contentSize)
        self.tableView.contentInset = UIEdgeInsetsMake(maxTop, 0, 0, 0)
    }
}
