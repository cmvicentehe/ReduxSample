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

    var rootViewController: UIViewController?

    DispatchQueue.main.sync {
        rootViewController = appDelegate.window?.rootViewController
    }

    guard let window = appDelegate.window,
        let rootViewControllerNotNil = rootViewController else {
            fatalError("No window or root view controller active")
    }

    let navigationState = NavigationStateImpl(rootViewController: rootViewControllerNotNil, window: window)

    return AppStateImpl(taskList: currentState.taskList, navigationState: navigationState)
}
