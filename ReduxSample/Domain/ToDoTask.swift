//
//  ToDoTask.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 06/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

enum TaskState {
    case unknown
    case toDo
    case done
}

struct ToDoTask {
    let identifier: String
    let name: String
    let dueDate: Date?
    let notes: String?
    let state: TaskState
}

extension ToDoTask: Equatable {}
