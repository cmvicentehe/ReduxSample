//
//  UpdateTaskReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 08/12/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func updateTaskReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    guard let updateTaskAction = action as? UpdateTaskAction else {
        fatalError("Invalid associated action")
    }

    let task = updateTaskAction.task
    let networkClient = updateTaskAction.networkClient
    update(taskList: currentState.taskList,
           task: task,
           networkClient: networkClient)

    return AppStateImpl(taskList: currentState.taskList,
                        selectedTask: nil,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .savingTask,
                        viewState: .notManaged,
                        networkClient: currentState.networkClient)
}

private func update(taskList: [ToDoTask],
                    task: ToDoTask,
                    networkClient: NetworkClient) {

    let taskListWithTaskToBeUpdated = taskList.compactMap { $0.identifier == task.identifier ? task : nil }
    if taskListWithTaskToBeUpdated.count > 0 {
        update(task: task,
               networkClient: networkClient)
    } else {
        create(task: task,
               networkClient: networkClient)
    }
}

private func create(task: ToDoTask, networkClient: NetworkClient) {
    let resource = AddTaskResource(identifier: task.identifier,
                                   name: task.name,
                                   dueDate: task.dueDate,
                                   notes: task.notes,
                                   state: task.state.rawValue,
                                   endPoint: Constants.Services.Endpoints.task)

    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    let toDo: ToDoTask.Type? = nil // TODO: Improve this code to avoid declaring var to infer the type
    networkClient.performRequest(for: resource, type: toDo) { _ in
        dispatchGroup.leave()
    }

    dispatchGroup.wait()
}

private func update(task: ToDoTask, networkClient: NetworkClient) {

    let resource = UpdateTaskResource(identifier: task.identifier,
                                      name: task.name,
                                      dueDate: task.dueDate,
                                      notes: task.notes,
                                      state: task.state.rawValue,
                                      endPoint: Constants.Services.Endpoints.task)

    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    // TODO: Improve this code to avoid declaring var to infer the type
    let toDo: ToDoTask.Type? = nil
    networkClient.performRequest(for: resource, type: toDo) { _ in
        dispatchGroup.leave()
    }

    dispatchGroup.wait()
}
