//
//  DeleteTaskAction.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 01/12/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct DeleteTaskAction {
    
    let taskIdentifier: String
    let networkClient: NetworkClient
}

extension DeleteTaskAction: Action {}
