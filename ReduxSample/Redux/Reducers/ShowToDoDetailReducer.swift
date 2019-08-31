//
//  ShowToDoDetailReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 28/08/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func showToDoDetailReducer(_ action: Action, _ state: State?) -> State {
    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    guard let showToDoDetailAction = action as? ShowToDoDetailAction else {
        fatalError("Invalid associated action")
    }

    let selectedTask = showToDoDetailAction.task
    let navigationState = currentState.navigationState

    let newState = AppStateImpl(taskList: currentState.taskList,
                                selectedTask: selectedTask,
                                navigationState: navigationState)

    if Thread.isMainThread {
        showToDoDetailVC(for: newState)
    } else {
        DispatchQueue.main.async {
            showToDoDetailVC(for: newState)
        }
    }

    return newState
}

private func showToDoDetailVC(for state: AppState) {
    let navigationState = state.navigationState
    let toDoDetailVC = ToDoDetailVC(state: state)
    navigationState?.show(viewController: toDoDetailVC, navigationStyle: .push)
}
