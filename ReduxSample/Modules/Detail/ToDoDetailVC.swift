//
//  ToDoDetailVC.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 28/08/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

class ToDoDetailVC: ReduxSampleVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let store = AppDelegateUtils.appDelegate?.store
        store?.replaceReducer(reducer: updateNavigationStateReducer)
        
        let updateNavigationStateAction = UpdateNavigationStateAction()
        dispatch(action: updateNavigationStateAction)
    }
}

extension ToDoDetailVC: ActionDispatcher {}
