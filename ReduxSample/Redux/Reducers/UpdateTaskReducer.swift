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
    let viewState = update(taskList: currentState.taskList,
           task: task,
           networkClient: networkClient)

    return AppStateImpl(taskList: currentState.taskList,
                        selectedTask: nil,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .savingTask,
                        viewState: viewState,
                        networkClient: currentState.networkClient)
}

private func update(taskList: [ToDoTask],
                    task: ToDoTask,
                    networkClient: NetworkClient) -> ViewState {

    let taskListWithTaskToBeUpdated = taskList.compactMap { $0.identifier == task.identifier ? task : nil }
    if taskListWithTaskToBeUpdated.count > 0 {
        return update(task: task,
               networkClient: networkClient)
    } else {
       return create(task: task,
               networkClient: networkClient)
    }
}

private func create(task: ToDoTask, networkClient: NetworkClient) -> ViewState {

    let resource = AddTaskResource(identifier: task.identifier,
                                   name: task.name,
                                   dueDate: task.dueDate,
                                   notes: task.notes,
                                   state: task.state.rawValue,
                                   endPoint: Constants.Services.Endpoints.task)

    var viewState: ViewState = .notHandled
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    networkClient.performRequest(for: resource, type: EmptyResponse.self) { result in
        viewState = manage(result: result)
        dispatchGroup.leave()
    }

    dispatchGroup.wait()
    return viewState
}

private func update(task: ToDoTask, networkClient: NetworkClient) -> ViewState {

    let resource = UpdateTaskResource(identifier: task.identifier,
                                      name: task.name,
                                      dueDate: task.dueDate,
                                      notes: task.notes,
                                      state: task.state.rawValue,
                                      endPoint: Constants.Services.Endpoints.task)

    var viewState: ViewState = .notHandled
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    networkClient.performRequest(for: resource, type: EmptyResponse.self) { result in
        
        viewState = manage(result: result)
        dispatchGroup.leave()
    }

    dispatchGroup.wait()
    return viewState
}

private func manage(result: Result<EmptyResponse, Error>) -> ViewState {
    switch result {
    case .success:
        return .notHandled
    case .failure(let error):
        return .error(error: error)
    }
}
