//
//  ShowAlertAction.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 03/03/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct ShowAlertAction {
    let message: String
    let buttonName: String
    let buttonCompletion: (() -> Void)?
}

extension ShowAlertAction: Action {}
