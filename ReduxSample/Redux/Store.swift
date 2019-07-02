//
//  Store.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 15/06/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

protocol StoreSuscriptor {
    var identifier: String { get set }

    func update(state: State)
}

protocol Store {

    var suscriptors: [StoreSuscriptor] { get set }

    func suscribe(_ suscriptor: StoreSuscriptor)
    func unsuscribe(_ suscriptor: StoreSuscriptor)
    func getState() -> State
    func dispatch(action: Action)
}
