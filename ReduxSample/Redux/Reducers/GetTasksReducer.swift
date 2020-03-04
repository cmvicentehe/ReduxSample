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
    let tasksResult = getTasks(from: networkClient)
    let viewState = tasksResult.0
    let toDoTaskList = tasksResult.1

    return AppStateImpl(taskList: toDoTaskList,
                        selectedTask: nil,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .notSelected,
                        viewState: viewState,
                        networkClient: currentState.networkClient)
}

private func getTasks(from networkClient: NetworkClient) -> (ViewState, [ToDoTask]) {

    let resource = GetTasksResource(endPoint: Constants.Services.Endpoints.tasks)
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    var tasksResult: (ViewState, [ToDoTask]) = (.fetched, [ToDoTask]())

    networkClient.performRequest(for: resource, type: [ToDoTask].self) { result in
        
        let resultTyped: Result<[ToDoTask]?, Error> = result as Result<[ToDoTask]?, Error>
        tasksResult = process(result: resultTyped)
        dispatchGroup.leave()
    }

    dispatchGroup.wait()
    return tasksResult
}

private func process(result: Result<[ToDoTask]?, Error>) -> (ViewState, [ToDoTask]) {

    switch result {

    case .success(let taskList):
        let toDoTaskList = taskList ?? []
        return (.fetched, toDoTaskList)
    case .failure(let error):
       return (.error(error: error), [])
    }
}
