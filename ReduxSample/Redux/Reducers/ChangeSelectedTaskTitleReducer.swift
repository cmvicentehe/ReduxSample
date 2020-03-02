//
//  ChangeSelectedTaskTitleReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 09/12/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func changeSelectedTaskTitleReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    guard let changeSelectedTaskTitleAction = action as? ChangeSelectedTaskTitleAction else {
        fatalError("Invalid associated action")
    }

    let taskIdentifier = changeSelectedTaskTitleAction.taskIdentifier
    let taskTitle = changeSelectedTaskTitleAction.taskTitle
    let selectedTask = currentState.selectedTask
    guard taskIdentifier == selectedTask?.identifier else {
        fatalError("Selected task is nil")
    }

    let updatedTask = ToDoTask(identifier: taskIdentifier,
                               name: taskTitle,
                               dueDate: selectedTask?.dueDate,
                               notes: selectedTask?.notes,
                               state: selectedTask?.state ?? .toDo)

    return AppStateImpl(taskList: currentState.taskList,
                        selectedTask: updatedTask,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .editingTask,
                        viewState: .notManaged,
                        networkClient: currentState.networkClient)
}
