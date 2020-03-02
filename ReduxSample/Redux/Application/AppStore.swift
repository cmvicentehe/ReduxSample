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

    deinit {
        suscriptors.forEach { unsuscribe($0) }
    }
}

extension AppStore: Store {

    func suscribe(_ suscriptor: StoreSuscriptor) {

        queue.async { [unowned self] in
            let result = self.suscriptors.filter { $0.identifier == suscriptor.identifier }
            let alreadyAdded = result.count > 0 ? true : false
            if !alreadyAdded {
                self.suscriptors.append(suscriptor) }
        }
    }

    func unsuscribe(_ suscriptor: StoreSuscriptor) {

        queue.async { [unowned self] in
            self.suscriptors = self.suscriptors.filter { $0.identifier != suscriptor.identifier }
        }
    }

    func getState() -> State {

        var state: State?
        DispatchQueue.global().sync { [unowned self] in
            state = self.state
        }

        guard let stateNotNil = state else {
            fatalError("Invalid state")
        }

        return stateNotNil
    }

    func dispatch(action: Action) {

        queue.async { [unowned self] in
            
            let newState = action.execute(for: self.reducer)
            self.state = newState
        }
    }

    func replaceReducer(reducer: @escaping Reducer) {

        queue.async { [unowned self] in
            self.reducer = reducer
        }
    }
}

private extension AppStore {
    
    func notify(newState: State) {
        queue.async { [unowned self] in
            self.suscriptors.forEach { $0.update(state: newState)}
        }
    }
}
