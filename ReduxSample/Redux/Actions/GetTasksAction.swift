//
//  GetTasksAction.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 27/02/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct GetTasksAction {
    let networkClient: NetworkClient
}

extension GetTasksAction: Action {}
