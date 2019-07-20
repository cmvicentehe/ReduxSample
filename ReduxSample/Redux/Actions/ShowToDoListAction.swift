//
//  ShowToDoListAction.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 16/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct ShowToDoListAction {}

extension ShowToDoListAction: Action {
    func execute(for reducer: Reducer) -> State {
        guard let state = AppDelegateUtils.appDelegate?.store?.getState() else {
            fatalError("State can´t be nil")
        }

       return reducer(self, state)
    }
}
