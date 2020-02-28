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
    let taskSelectionState: TaskSelectionState = (currentState.taskSelectionState == .addingTask) ? .addingTask : .editingTask

    let newState = AppStateImpl(taskList: currentState.taskList,
                                selectedTask: selectedTask,
                                navigationState: navigationState,
                                taskSelectionState: taskSelectionState)

    showToDoDetailOnMainOrBackground(with: newState)

    return newState
}

private func showToDoDetailOnMainOrBackground(with newState: AppState) {

    if Thread.isMainThread {
        showToDoDetailVC(for: newState)
    } else {
        DispatchQueue.main.async {
            showToDoDetailVC(for: newState)
        }
    }
}

private func showToDoDetailVC(for state: AppState) {

    let navigationState = state.navigationState
    let viewModel = toDoViewModel(for: state)
    let toDoDetailVC = ToDoDetailVC(state: state, viewModel: viewModel, suscriber: viewModel)
    navigationState?.show(viewController: toDoDetailVC, navigationStyle: .push)
}

private func toDoViewModel(for state: AppState) -> ToDoViewModel? {
    
    guard let selectedTask = state.selectedTask else {
        print("There is no seleceted task. Adding task state")
        return nil
    }

    let isCompleted = (selectedTask.state == .done) ? true : false
    let formatterType = FormatterType.default
    let date = CustomDateFormatter.convertDateToString(date: selectedTask.dueDate, with: formatterType)

    return ToDoViewModel(taskIdentifier: selectedTask.identifier,
                         title: selectedTask.name,
                         date: date,
                         notes: selectedTask.notes ?? "--",
                         isSelected: isCompleted)
}
