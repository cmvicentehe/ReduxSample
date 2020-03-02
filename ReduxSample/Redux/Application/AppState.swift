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
    var selectedTask: ToDoTask? { get }
    var navigationState: NavigationState? { get }
    var taskSelectionState: TaskSelectionState { get }
    var viewState: ViewState { get }
    var networkClient: NetworkClient { get }
}

enum ViewState {

    case fetching
    case fetched
    case notManaged
}

enum TaskSelectionState {

    case notSelected
    case editingTask
    case addingTask
    case deletingTask
    case savingTask
}

struct AppStateImpl {
    
    private(set) var taskList: [ToDoTask]
    private(set) var selectedTask: ToDoTask?
    private(set) var navigationState: NavigationState?
    private(set) var taskSelectionState: TaskSelectionState = .notSelected
    private(set) var viewState: ViewState
    private(set) var networkClient: NetworkClient
}

extension AppStateImpl: AppState {}
