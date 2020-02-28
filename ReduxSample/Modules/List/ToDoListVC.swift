//
//  TodoListVC.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 15/06/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

class ToDoListVC: ReduxSampleVC {

    let toDoListDataSource: ToDoListDataSource

    init(state: AppState, toDoListDataSource: ToDoListDataSource, suscriber: Suscriber? = nil) {

        self.toDoListDataSource = toDoListDataSource
        super.init(state: state, suscriber: suscriber)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Invalid init method use (init(state: , suscriber:)) instead")
    }
}

// MARK: ViewController life cycle
extension ToDoListVC {
    override func viewDidLoad() {

        super.viewDidLoad()
        setUpViews()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        toDoListDataSource.resetTableView()
        getTasks()
    }
}

private extension ToDoListVC {

    func setUpViews() {

        setUpNavigationRightButton()
        setUpToDoList()
    }

    func setUpToDoList() {

        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        setUpConstraints(to: tableView)
        toDoListDataSource.setUp(tableView: tableView)
    }

    func setUpNavigationRightButton() {

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(userDidTapAddButton))
        navigationItem.setRightBarButton(addButton, animated: true)
    }

    func setUpConstraints(to tableView: UITableView) {
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func getTasks() {
        replaceReducerByGetTasksReducer()
        dispatchGetTasksAction()
    }

    func replaceReducerByGetTasksReducer() {

         let store = AppDelegateUtils.appDelegate?.store
         store?.replaceReducer(reducer: getTasksReducer)
    }

    func dispatchGetTasksAction() {

        let networkClient = NetworkClientImpl()
        let getTasksAction = GetTasksAction(networkClient: networkClient)
        dispatch(action: getTasksAction)
    }

}

// MARK: Action methods
extension ToDoListVC {

    @objc func userDidTapAddButton() {
        toDoListDataSource.addTask()
    }
}
