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
    func resetTableView()
    func addTask()
}

class ToDoListDataSourceImpl: NSObject {

    var state: AppState
    var tableView: UITableView?
    var hasToShowDetail: Bool = false

    init(state: AppState) {
        self.state = state
        super.init()
    }
}

// MARK: UITableViewDataSource methods
extension ToDoListDataSourceImpl: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.taskList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = ToDoCellConstants.cellIdentifier
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ToDoCell) ?? ToDoCell(style: .default, reuseIdentifier: cellIdentifier)

        let task = state.taskList[indexPath.row]
        let isSelected = task.state == .done ? true : false
        let date = CustomDateFormatter.convertDateToString(date: task.dueDate,
                                                           with: .default)
        let viewModel = ToDoViewModel(taskIdentifier: task.identifier, title: task.name, date: date, notes: "--", isSelected: isSelected)
        cell.bind(viewModel: viewModel)
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            let task = state.taskList[indexPath.row]
            let taskIdentifier = task.identifier
            replaceReducerByDeleteTaskReducer()
            dispatchDeleteTaskAction(with: taskIdentifier)
        }
    }
}

// MARK: UITableViewDelegate methods
extension ToDoListDataSourceImpl: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let task = state.taskList[indexPath.row]
        replaceReducerByShowToDoDetailReducer()
        dispatchShowToDoDetailAction(with: task)
    }
}

// MARK: Redux
extension ToDoListDataSourceImpl: ToDoListDataSource {

    func resetTableView() {

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(ToDoCell.self, forCellReuseIdentifier: ToDoCellConstants.cellIdentifier)
        tableView?.estimatedRowHeight = CGFloat(ToDoCellConstants.estimatedRowHeight)
        tableView?.rowHeight = UITableView.automaticDimension
    }

    func setUp(tableView: UITableView) {

        self.tableView = tableView
        resetTableView()
    }

    func addTask() {

        hasToShowDetail = true
        replaceReducerByAddTaskReducer()
        dispatchAddTaskAction()
    }
}

// MARK: Suscriber methods
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

// MARK: StoreSuscriptor methods
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

        getTasksIfNeeded()

        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }

        showToDoDetailViewIfNeeded(for: self.state)
    }
}

// MARK: Action Dispatcher
extension ToDoListDataSourceImpl: ActionDispatcher {}

// MARK: Redux Actions
private extension ToDoListDataSourceImpl {

    func replaceReducerByShowToDoDetailReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: showToDoDetailReducer)
    }

    func replaceReducerByDeleteTaskReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: deleteTaskReducer)
    }

    func replaceReducerByAddTaskReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: addTaskReducer)
    }

    func replaceReducerByHideActivityIndicatorReducer() {

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: hideActivityIndicatorReducer)
    }

    func replaceReducerByGetTasksReducer() {

         let store = AppDelegateUtils.appDelegate?.store
         store?.replaceReducer(reducer: getTasksReducer)
    }

    func dispatchDeleteTaskAction(with identifier: String) {

        let networkClient = state.networkClient
        let deleteTaskAction = DeleteTaskAction(taskIdentifier: identifier,
                                                networkClient: networkClient)
        dispatch(action: deleteTaskAction)
    }

    func dispatchShowToDoDetailAction(with task: ToDoTask) {

        let showToDoDetailAction = ShowToDoDetailAction(task: task)
        dispatch(action: showToDoDetailAction)
    }

    func dispatchAddTaskAction() {

        let addTaskAction = AddTaskAction()
        dispatch(action: addTaskAction)
    }

    func dispatchHideActivityIndicatorAction() {

        let hideActivityIndicatorAction = HideActivityIndicatorAction()
        dispatch(action: hideActivityIndicatorAction)
    }

    func dispatchGetTasksAction() {

        let networkClient = state.networkClient
        let getTasksAction = GetTasksAction(networkClient: networkClient)
        dispatch(action: getTasksAction)
    }

    func getTasksIfNeeded() {

        switch state.viewState {
        case .fetching:
            replaceReducerByGetTasksReducer()
            dispatchGetTasksAction()
        case .fetched:
            replaceReducerByHideActivityIndicatorReducer()
            dispatchHideActivityIndicatorAction()
        case .notHandled, .activityIndicatorRequired, .finish:
            break
        }
    }
}

// MARK: Private methods
private extension ToDoListDataSourceImpl {

    func showToDoDetailViewIfNeeded(for state: AppState) {
        
        if state.taskSelectionState == .addingTask &&
            hasToShowDetail {

            guard let task = state.selectedTask else {
                print("Invalid selected task")
                return
            }
            
            replaceReducerByShowToDoDetailReducer()
            dispatchShowToDoDetailAction(with: task)
            hasToShowDetail = false
        }
    }
}
