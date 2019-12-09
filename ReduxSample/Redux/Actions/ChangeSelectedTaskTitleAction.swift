//
//  ChangeSelectedTaskTitleAction.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 09/12/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct ChangeSelectedTaskTitleAction {
    let taskIdentifier: String
    let taskTitle: String
}

extension ChangeSelectedTaskTitleAction: Action {}
