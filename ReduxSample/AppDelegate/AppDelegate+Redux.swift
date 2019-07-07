//
//  AppDelegate+Redux.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 16/06/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

protocol Redux {
    func createReducer() -> [Reducer]
    func createState() -> State
    func createSuscriptors() -> [StoreSuscriptor]
    func createQueue() -> DispatchQueue
    func createStore(reducers: [Reducer], state: State, suscriptors: [StoreSuscriptor], queue: DispatchQueue) -> Store
}

extension AppDelegate: Redux {

    func createReducer() -> [Reducer] {
        return [Reducer]()
    }

    func createState() -> State {
        let taskList = [ToDoTask]()
        return AppState(taskList: taskList)
    }

    func createSuscriptors() -> [StoreSuscriptor] {
        return [StoreSuscriptor]()
    }

    func createQueue() -> DispatchQueue {
        return DispatchQueue(label: "com.cmvicentehe.redux")
    }

    func createStore(reducers: [Reducer], state: State, suscriptors: [StoreSuscriptor], queue: DispatchQueue) -> Store {
        return AppStore(reducers: [], state: state, suscriptors: suscriptors, queue: queue)
    }
}
