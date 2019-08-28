//
//  ActionDispatcher.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 28/08/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

protocol ActionDispatcher {
    func dispatch(action: Action)
}

extension ActionDispatcher {

    func dispatch(action: Action) {
        AppDelegateUtils.appDelegate?.store?.dispatch(action: action)
    }
}
