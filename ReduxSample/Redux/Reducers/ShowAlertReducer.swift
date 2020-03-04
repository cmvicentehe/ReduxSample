//
//  ShowAlertReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 03/03/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

func showAlertReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    guard let showAlertAction = action as? ShowAlertAction else {
        fatalError("Invalid associated action")
    }

    let message = showAlertAction.message
    let buttonName = showAlertAction.buttonName
    let completion = showAlertAction.buttonCompletion

    let newState = AppStateImpl(taskList: currentState.taskList,
                                selectedTask: currentState.selectedTask,
                                navigationState: currentState.navigationState,
                                taskSelectionState: currentState.taskSelectionState,
                                viewState: .notHandled,
                                networkClient: currentState.networkClient)

   showAlertVC(for: newState,
               with: message,
               buttonName: buttonName,
               buttonCompletion: completion)

    return newState
}

private func showAlertVC(for state: AppState, with message: String, buttonName: String, buttonCompletion: (() -> Void)?) {

    let navigationState = state.navigationState
    let alertController = UIAlertController(title: "ReduxSample",
                                            message: message,
                                            preferredStyle: .alert)
    let action = UIAlertAction(title: buttonName,
                               style: .default) { _ in
                               buttonCompletion?()
    }
    alertController.addAction(action)
    navigationState?.show(viewController: alertController, navigationStyle: .modal)
}
