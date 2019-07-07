//
//  AppDelegate+Utils.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 07/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

struct AppDelegateUtils {
    static var appDelegate: AppDelegate? = {
        return UIApplication.shared.delegate as? AppDelegate
    }()
}
