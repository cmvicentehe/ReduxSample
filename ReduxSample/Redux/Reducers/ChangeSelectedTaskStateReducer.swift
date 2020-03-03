//
//  ChangeSelectedTaskStateReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 09/12/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func changeSelectedTaskStateReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    guard let changeSelectedTaskStateAction = action as? ChangeSelectedTaskStateAction else {
        fatalError("Invalid associated action")
    }

    let taskIdentifier = changeSelectedTaskStateAction.taskIdentifier
    let taskState = changeSelectedTaskStateAction.taskState
    let selectedTask = currentState.selectedTask
    guard taskIdentifier == selectedTask?.identifier else {
        fatalError("Selected task is nil")
    }

    let updatedTask = ToDoTask(identifier: taskIdentifier,
                               name: selectedTask?.name ?? "",
                               dueDate: selectedTask?.dueDate,
                               notes: selectedTask?.notes,
                               state: taskState)

    return AppStateImpl(taskList: currentState.taskList,
                        selectedTask: updatedTask,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .editingTask,
                        viewState: .notHandled,
                        networkClient: currentState.networkClient)
}
