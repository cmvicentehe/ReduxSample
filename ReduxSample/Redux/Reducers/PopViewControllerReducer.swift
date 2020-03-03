//
//  PopViewControllerReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 01/12/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation
import UIKit

func popViewControllerReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    let navigationState = currentState.navigationState
    let rootViewController = navigationState?.rootViewController

    DispatchQueue.main.async {
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
        } else {
            rootViewController?.navigationController?.popViewController(animated: true)
        }

        if let currentRootVC = navigationState?.window.rootViewController {
            navigationState?.updateRootViewController(with: currentRootVC)
        }
    }

    return AppStateImpl(taskList: currentState.taskList,
                        selectedTask: nil,
                        navigationState: navigationState,
                        taskSelectionState: .notSelected,
                        viewState: .notHandled,
                        networkClient: currentState.networkClient)
}
