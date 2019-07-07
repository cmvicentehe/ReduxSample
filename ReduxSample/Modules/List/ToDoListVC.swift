//
//  TodoListVC.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 15/06/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

class ToDoListVC: UIViewController {

    lazy var toDoListDataSource: ToDoListDataSource = {
        return ToDoListDataSourceImpl(state: state)
    }()

    var state: State

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(state: State) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
}

// MARK: View life cycle
extension ToDoListVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpToDoList()
        suscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsuscribe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        unsuscribe()
    }
}

private extension ToDoListVC {

    func setUpToDoList() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        setUpConstraints(to: tableView)
        toDoListDataSource.setUp(tableView: tableView)
    }

    func setUpConstraints(to tableView: UITableView) {
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func suscribe() {
        toDoListDataSource.suscribe()
    }

    func unsuscribe() {
        toDoListDataSource.unsuscribe()
    }
}
