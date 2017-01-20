//
//  FloatingMenuController.swift
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 1/19/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

import SnapKit
import UIKit

class FloatingMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView.init(frame: self.view.bounds)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.backgroundColor = UIColor.clear
        self.tableView?.tableFooterView = UIView.init()
        self.tableView?.separatorStyle = .none
        self.view.addSubview(self.tableView!)

        self.view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
    }

    // MARK: - UITableView

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier")

        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "identifier")
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.textColor = UIColor.white
        }

        cell?.textLabel?.text = "cell \(indexPath.row)"

        return cell!
    }
}
