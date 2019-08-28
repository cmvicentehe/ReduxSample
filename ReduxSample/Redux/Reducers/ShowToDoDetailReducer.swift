//
//  ShowToDoDetailReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 28/08/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func showToDoDetailReducer(_ action: Action, _ state: State?) -> State {
    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    // TODO: Implement!!
    return currentState
}
