//
//  UpdateTaskSelectionStateReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 03/03/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func updateTaskSelectionStateReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    guard let updateTaskSelectionStateAction = action as? UpdateTaskSelectionStateAction else {
        fatalError("Invalid associated action")
    }

    let taskSelectionState = updateTaskSelectionStateAction.taskSelectionState

    return AppStateImpl(taskList: currentState.taskList,
                        selectedTask: currentState.selectedTask,
                        navigationState: currentState.navigationState,
                        taskSelectionState: taskSelectionState,
                        viewState: .displayActivityIndicatorRequired,
                        networkClient: currentState.networkClient)
}
