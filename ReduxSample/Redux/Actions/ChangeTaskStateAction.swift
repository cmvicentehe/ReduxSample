//
//  ChangeTaskStateAction.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 14/08/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct ChangeTaskStateAction {
    let taskIdentifier: String
}

extension ChangeTaskStateAction: Action {
    func execute(for reducer: @escaping Reducer) -> State {
        guard let state = AppDelegateUtils.appDelegate?.store?.getState() else {
            fatalError("State can´t be nil")
        }

        return reducer(self, state)
    }
}
