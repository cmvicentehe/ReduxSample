//
//  ChangeSelectedTaskDateAction.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 09/11/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct ChangeSelectedTaskDateAction {
    
    let date: Date
}

extension ChangeSelectedTaskDateAction: Action {}
