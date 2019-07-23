//
//  AppState.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 29/06/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

protocol AppState: State {
    var taskList: [ToDoTask] { get }
    var navigationState: NavigationState? { get }
}

struct AppStateImpl {
    private(set) var taskList: [ToDoTask]
    private(set) var navigationState: NavigationState?
}

extension AppStateImpl: AppState {}
