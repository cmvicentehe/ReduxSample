//
//  UpdateSelectedTaskReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 09/12/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func updateSelectedTaskReducer(_ action: Action, _ state: State?) -> State {
    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    guard let updateSelectedTaskAction = action as? UpdateSelectedTaskAction else {
        fatalError("Invalid associated action")
    }

    let task = updateSelectedTaskAction.task

    return AppStateImpl(taskList: currentState.taskList,
                        selectedTask: task,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .editingTask)
}
