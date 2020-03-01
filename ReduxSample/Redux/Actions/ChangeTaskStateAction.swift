//
//  ChangeTaskStateAction.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 14/08/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct ChangeTaskStateAction {
    
    let taskIdentifier: String
    let networkClient: NetworkClient
}

extension ChangeTaskStateAction: Action {}
