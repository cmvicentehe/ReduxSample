//
//  HideActivityIndicatorReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 02/03/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

func hideActivityIndicatorReducer(_ action: Action, _ state: State?) -> State {

    guard let currentState = AppDelegateUtils.appDelegate?.store?.getState() as? AppState else {
        fatalError("Invalid state")
    }

    let navigationState = currentState.navigationState
    DispatchQueue.main.async {
        if let navigationController = navigationState?.rootViewController as? UINavigationController,
            let topViewController = navigationController.topViewController as? ReduxSampleVC {
            topViewController.hideActivityIndicator()
        }
    }

    return AppStateImpl(taskList: currentState.taskList,
                        selectedTask: currentState.selectedTask,
                        navigationState: currentState.navigationState,
                        taskSelectionState: currentState.taskSelectionState,
                        viewState: .finish,
                        networkClient: currentState.networkClient)
}
