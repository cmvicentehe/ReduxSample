//
//  Action.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 15/06/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

protocol Action {
    func execute(for reducer: @escaping Reducer) -> State
}
