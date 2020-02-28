//
//  GetTasksReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 27/02/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func getTasksReducer(_ action: Action, _ state: State?) -> State {

    guard let currentState = AppDelegateUtils.appDelegate?.store?.getState() as? AppState else {
        fatalError("Invalid state")
    }

    guard let getTasksAction = action as? GetTasksAction else {
        fatalError("Invalid associated action")
    }

    let networkClient = getTasksAction.networkClient
    let toDoTaskList = getTasks(from: networkClient)

    return AppStateImpl(taskList: toDoTaskList,
                        selectedTask: nil,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .notSelected)
}

private func getTasks(from networkClient: NetworkClient) -> [ToDoTask] {

    let resource = GetTasksResource(endPoint: Constants.Services.Endpoints.tasks)
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    var taskList = [ToDoTask]()
    networkClient.performRequest(for: resource, type: [ToDoTask].self) { result in
        let resultTyped: Result<[ToDoTask]?, Error> = result as Result<[ToDoTask]?, Error>
        taskList = process(result: resultTyped)
        dispatchGroup.leave()
    }

    dispatchGroup.wait()
    return taskList
}

private func process(result: Result<[ToDoTask]?, Error>) -> [ToDoTask] {

    switch result {
    case .success(let taskList):
        return taskList ?? []
    case .failure(let error):
        print("Error \(error)")
        // TODO: Error Handling
        return []
    }
}
