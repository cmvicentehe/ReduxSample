//
//  AppDelegate+Utils.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 07/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

struct AppDelegateUtils {
    static var appDelegate: AppDelegate? {

        if Thread.isMainThread {
            return AppDelegateUtils.getAppDelegate()
        }

        var appDelegate: AppDelegate?
        
        DispatchQueue.main.sync {
            appDelegate = AppDelegateUtils.getAppDelegate()
        }

        return appDelegate
    }
}

private extension AppDelegateUtils {
    static func getAppDelegate() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
}
