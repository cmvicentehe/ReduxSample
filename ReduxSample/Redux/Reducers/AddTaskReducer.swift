//
//  AddTaskReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 14/12/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func addTaskReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    let taskList = currentState.taskList
    let identifier = UUID().uuidString

    let task = ToDoTask(identifier: String(identifier),
                        name: "",
                        dueDate: nil,
                        notes: nil,
                        state: .toDo)
    
    return AppStateImpl(taskList: taskList,
                        selectedTask: task,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .addingTask,
                        networkClient: currentState.networkClient)
}
