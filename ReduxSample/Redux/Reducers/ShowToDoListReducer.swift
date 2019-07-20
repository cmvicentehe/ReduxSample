//
//  ShowToDoListReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 19/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func showToDoListReducer(_ action: Action, _ state: State?) -> State {
    // TODO: retrieve list from somewhere API/CoreData...
    let task1 = ToDoTask(identifier: "1", name: "task 1", dateToBeDone: nil, notes: nil, state: .toDo)
    let task2 = ToDoTask(identifier: "2", name: "task 2", dateToBeDone: nil, notes: nil, state: .toDo)
    let task3 = ToDoTask(identifier: "3", name: "task 3", dateToBeDone: nil, notes: nil, state: .toDo)
    return AppStateImpl(taskList: [task1, task2, task3])
}
