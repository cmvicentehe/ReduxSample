//
//  ShowToDoListReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 19/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func showToDoListReducer(_ action: Action, _ state: State?) -> State {
    
    guard let currentState = AppDelegateUtils.appDelegate?.store?.getState() as? AppState else {
        fatalError("Invalid state")
    }

    return AppStateImpl(taskList: currentState.taskList,
                        selectedTask: nil,
                        navigationState: currentState.navigationState,
                        taskSelectionState: .notSelected,
                        viewState: .notManaged,
                        networkClient: currentState.networkClient)
}
