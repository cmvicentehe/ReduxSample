//
//  UpdateTaskAction.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 08/12/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct UpdateTaskAction {
    let task: ToDoTask
}

extension UpdateTaskAction: Action {}
