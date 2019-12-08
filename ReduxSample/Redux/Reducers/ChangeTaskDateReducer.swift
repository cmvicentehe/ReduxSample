//
//  ChangeTaskDateReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 09/11/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func changeTaskDateReducer(_ action: Action, _ state: State?) -> State {
    
    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }
    
    guard let changeTaskAction = action as? ChangeTaskDateAction else {
        fatalError("Invalid associated action")
    }
    
    let date = changeTaskAction.date
    guard let taskIdentifier = currentState.selectedTask?.identifier,
        let taskToBeModified = task(for: taskIdentifier, currentState: currentState) else {
            fatalError("Task is nil")
    }
    
    let task = changeTaskDate(for: taskToBeModified, date: date)
    let updatedTaskList = currentState.taskList.compactMap { $0.identifier == task.identifier ? task : $0}
    
    return AppStateImpl(taskList: updatedTaskList,
                        selectedTask: task,
                        navigationState: currentState.navigationState,
                        taskSelectionState: currentState.taskSelectionState)
}

private func task(for identifier: String, currentState: AppState) -> ToDoTask? {
    
    let task = currentState.taskList
        .filter { $0.identifier == identifier }
        .reduce(nil) { _, task in
            return task
    }
    return task
}

private func changeTaskDate(for taskToBeModified: ToDoTask, date: Date) -> ToDoTask {
    return ToDoTask(identifier: taskToBeModified.identifier,
                    name: taskToBeModified.name,
                    dueDate: date,
                    notes: taskToBeModified.notes,
                    state: taskToBeModified.state)
}
