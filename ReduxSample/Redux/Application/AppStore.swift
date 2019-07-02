//
//  AppStore.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 29/06/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

class AppStore {
    private(set) var reducers: [Reducer]
    private var state: State // TODO: What to do withState? create a global state with substates?
    var suscriptors: [StoreSuscriptor]
    let queue: DispatchQueue

    init(reducers: [Reducer], state: State, suscriptors: [StoreSuscriptor], queue: DispatchQueue) {
        self.reducers = reducers
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
        // TODO: Implement!
    }
}
