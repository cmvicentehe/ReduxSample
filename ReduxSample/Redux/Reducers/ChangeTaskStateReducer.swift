//
//  ChangeTaskStateReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 14/08/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func changeTaskStateReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    guard let changeTaskAction = action as? ChangeTaskStateAction else {
        fatalError("Invalid associated action")
    }

    let taskIdentifier = changeTaskAction.taskIdentifier
    guard let taskToBeModified = task(for: taskIdentifier, currentState: currentState) else {
        fatalError("Task is nil")
    }

    let task = changeTaskState(for: taskToBeModified)
    let networkClient = changeTaskAction.networkClient
    let updatedTaskList = currentState.taskList.compactMap { $0.identifier == task.identifier ? task : $0}

    update(task: task,
           networkClient: networkClient)

    return AppStateImpl(taskList: updatedTaskList,
                        selectedTask: task,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .editingTask,
                        networkClient: currentState.networkClient)
}

private func task(for identifier: String, currentState: AppState) -> ToDoTask? {

    let task = currentState.taskList
        .filter { $0.identifier == identifier }
        .reduce(nil) { _, task in
            return task
        }
    return task
}

private func changeTaskState(for task: ToDoTask) -> ToDoTask {
    
    var newState: TaskState = .unknown

    switch task.state {
    case .toDo:
        newState = .done
    case .done:
        newState = .toDo
    default:
        newState = .unknown
    }

    return ToDoTask(identifier: task.identifier,
                    name: task.name,
                    dueDate: task.dueDate,
                    notes: task.notes,
                    state: newState)
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
    let toDo: ToDoTask.Type? = nil
    // TODO: Improve this code to avoid declaring var to infer the type
    networkClient.performRequest(for: resource, type: toDo) { _ in
        dispatchGroup.leave()
    }

    dispatchGroup.wait()
}
