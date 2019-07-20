//
//  AppStore.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 29/06/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

class AppStore {
    var suscriptors: [StoreSuscriptor]
    let queue: DispatchQueue
    private(set) var reducer: Reducer
    private var state: State {
        didSet {
            notify(newState: state)
        }
    }

    init(reducer: @escaping Reducer, state: State, suscriptors: [StoreSuscriptor], queue: DispatchQueue) {
        self.reducer = reducer
        self.state = state
        self.suscriptors = suscriptors
        self.queue = queue
    }
}

extension AppStore: Store {

    func suscribe(_ suscriptor: StoreSuscriptor) {
        queue.async { [unowned self] in
            let result = self.suscriptors.compactMap { $0.identifier == suscriptor.identifier }
            let alreadyAdded = result.count > 0 ? true : false
            if !alreadyAdded { self.suscriptors.append(suscriptor) }
        }
    }

    func unsuscribe(_ suscriptor: StoreSuscriptor) {
        queue.async { [unowned self] in
            self.suscriptors = self.suscriptors.filter { $0.identifier != suscriptor.identifier }
        }
    }

    func getState() -> State {
        return state
    }

    func dispatch(action: Action) {
        queue.async { [weak self] in
            guard let reducerNotNil = self?.reducer else {
                fatalError("Reducer can´t be nil")
            }

            let newState = action.execute(for: reducerNotNil)
            self?.state = newState
        }
    }

    func replaceReducer(reducer: @escaping Reducer) {
        queue.async { [weak self] in
            self?.reducer = reducer
        }
    }
}

private extension AppStore {
    func notify(newState: State) {
        queue.async { [weak self] in
            self?.suscriptors.forEach { $0.update(state: newState)}
        }
    }
}
