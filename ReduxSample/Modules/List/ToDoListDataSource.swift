//
//  ToDoListDataSource.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 06/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

protocol ToDoListDataSource {
    func setUp(tableView: UITableView)
}

class ToDoListDataSourceImpl: NSObject {
    var state: AppState
    var tableView: UITableView?

    init(state: AppState) {
        self.state = state
        super.init()
    }
}

extension ToDoListDataSourceImpl: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.taskList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = ToDoCellConstants.cellIdentifier
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ToDoCell) ?? ToDoCell(style: .default, reuseIdentifier: cellIdentifier)

        let task = state.taskList[indexPath.row]
        let isSelected = task.state == .done ? true : false
        let formatterType = FormatterType.default
        let date = CustomDateFormatter.convertDateToString(date: task.dueDate, with: formatterType)
        let viewModel = ToDoViewModel(taskIdentifier: task.identifier, title: task.name, date: date, notes: "", isSelected: isSelected)
        cell.bind(viewModel: viewModel)

        return cell
    }
}

extension ToDoListDataSourceImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: showToDoDetailReducer)
        let task = state.taskList[indexPath.row]
        let showToDoDetailAction = ShowToDoDetailAction(task: task)
        store?.dispatch(action: showToDoDetailAction)
    }
}

// MARK: Redux
extension ToDoListDataSourceImpl: ToDoListDataSource {

    func setUp(tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = CGFloat(ToDoCellConstants.estimatedRowHeight)
        self.tableView = tableView
    }
}

extension ToDoListDataSourceImpl: Suscriber {
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
        guard let newState = state as? AppState else {
            fatalError("There is no a valid state")
        }
        
        self.state = newState

        DispatchQueue.main.async { [unowned self] in
            self.tableView?.reloadData()
        }
    }
}
