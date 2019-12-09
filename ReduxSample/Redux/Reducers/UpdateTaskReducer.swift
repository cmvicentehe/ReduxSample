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
    let updatedTaskList = currentState.taskList.compactMap { $0.identifier == task.identifier ? task : $0}

    return AppStateImpl(taskList: updatedTaskList,
                        selectedTask: nil,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .savingTask)
}