//
//  ToDoListDataSource.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 06/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

struct ToDoListDataSourceConstants {
    static let cellIdentifier = "ToDoCell"
}

protocol ToDoListDataSource {
    func setUp(tableView: UITableView)
    func suscribe()
    func unsuscribe()
}

class ToDoListDataSourceImpl: NSObject {
    var state: State
    var tableView: UITableView?

    init(state: State) {
        self.state = state
        super.init()
    }
}

extension ToDoListDataSourceImpl: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = ToDoListDataSourceConstants.cellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)

        cell.textLabel?.text = "Cell \(indexPath.row)"
        return cell
    }
}

extension ToDoListDataSourceImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell selected at index path \(indexPath.row)")
    }
}

// MARK: Redux
extension ToDoListDataSourceImpl: ToDoListDataSource {

    func setUp(tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView = tableView
    }
    
    func suscribe() {
        guard let appDelegate = AppDelegateUtils.appDelegate else {
            return
        }

        appDelegate.suscribe(self)
    }
    
    func unsuscribe() {
        guard let appDelegate = AppDelegateUtils.appDelegate else {
            return
        }

        appDelegate.unsuscribe(self)
    }
}

extension ToDoListDataSourceImpl: StoreSuscriptor {
    var identifier: String {
        let type = ToDoListDataSourceImpl.self
        return String(describing: type)
    }

    func update(state: State) {
        self.state = state
        tableView?.reloadData()
    }
}
