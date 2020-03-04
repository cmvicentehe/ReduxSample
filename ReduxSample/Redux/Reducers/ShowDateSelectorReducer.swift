//
//  ShowDateSelectorReducer.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 26/10/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

func showDateSelectorReducer(_ action: Action, _ state: State?) -> State {

    guard let appDelegate = AppDelegateUtils.appDelegate,
        let currentState = appDelegate.store?.getState() as? AppState else {
            fatalError("Invalid AppDelegate or State")
    }
    
    let newState = AppStateImpl(taskList: currentState.taskList,
                                selectedTask: currentState.selectedTask,
                                navigationState: currentState.navigationState,
                                taskSelectionState: .editingTask,
                                viewState: .notHandled,
                                networkClient: currentState.networkClient)

    DispatchQueue.main.async {
        showDateSelectorVC(for: newState)
    }

    return newState
}

private func showDateSelectorVC(for state: AppState) {
    
    let navigationState = state.navigationState
    let dateSelectorVC = DateSelectorVC(state: state)
    dateSelectorVC.modalPresentationStyle = .overCurrentContext
    navigationState?.show(viewController: dateSelectorVC, navigationStyle: .modal)
}
