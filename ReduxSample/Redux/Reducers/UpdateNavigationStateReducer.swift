//
//  UpdateNavigationStateReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 21/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

func updateNavigationStateReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }

    let viewController: UIViewController? = rootViewController(appDelegate: appDelegate)

    guard let window = appDelegate.window,
        let rootViewControllerNotNil = viewController else {
            fatalError("No window or root view controller active")
    }

    let navigationState = NavigationStateImpl(rootViewController: rootViewControllerNotNil, window: window)

    return AppStateImpl(taskList: currentState.taskList,
                        selectedTask: currentState.selectedTask,
                        navigationState: navigationState,
                        taskSelectionState: currentState.taskSelectionState,
                        viewState: .notManaged,
                        networkClient: currentState.networkClient)
}

private func rootViewController(appDelegate: AppDelegate) -> UIViewController? {
    
    var rootViewController: UIViewController?
    if Thread.isMainThread {
        rootViewController = appDelegate.window?.rootViewController
    } else {
        DispatchQueue.main.sync {
            rootViewController = appDelegate.window?.rootViewController
        }
    }

    return rootViewController
}
