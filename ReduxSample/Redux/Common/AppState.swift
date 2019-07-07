//
//  AppState.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 29/06/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct AppState {
    let taskList: [ToDoTask]
}

extension AppState: State {}
