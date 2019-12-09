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
    let updatedTaskList = currentState.taskList.filter { $0.identifier != taskIdentifier }

    return AppStateImpl(taskList: updatedTaskList, selectedTask: nil, navigationState: currentState.navigationState, taskSelectionState: .deletingTask)
}
