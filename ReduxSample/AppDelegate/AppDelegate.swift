//
//  AppDelegate.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 15/06/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private(set) var store: Store?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let reducers = createReducer()
        let state = createState()
        let suscriptors = createSuscriptors()
        let queue =  createQueue()

        store = createStore(reducers: reducers, state: state, suscriptors: suscriptors, queue: queue)

        return true
    }
}
