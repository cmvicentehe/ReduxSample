//
//  DeleteTaskReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 01/12/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func deleteTaskReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    guard let deleteTaskAction = action as? DeleteTaskAction else {
        fatalError("Invalid associated action")
    }

    let taskIdentifier = deleteTaskAction.taskIdentifier
    let networkClient = deleteTaskAction.networkClient
    let updatedTaskList = deleteTask(with: taskIdentifier,
                                     in: currentState.taskList,
                                     networkClient: networkClient)

    return AppStateImpl(taskList: updatedTaskList,
                        selectedTask: nil,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .deletingTask)
}

private func deleteTask(with identifier: String, in taskList: [ToDoTask], networkClient: NetworkClient) -> [ToDoTask] {

    let endpoint = Constants.Services.Endpoints.deleteTask.replacingOccurrences(of: Constants.Services.Endpoints.taskIdPlaceholder, with: identifier)
    let resource = DeleteTaskResource(endPoint: endpoint)
    let dispatchGroup = DispatchGroup()
    var updatedTaskList = taskList

    dispatchGroup.enter()
    let toDo: ToDoTask.Type? = nil
    networkClient.performRequest(for: resource, type: toDo) { _ in
        dispatchGroup.leave()
        updatedTaskList = taskList.filter { $0.identifier != identifier }
    }

    dispatchGroup.wait()
    return updatedTaskList
}
