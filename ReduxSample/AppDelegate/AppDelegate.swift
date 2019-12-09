//
//  AppDelegate.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 15/06/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import UIKit

protocol ReduxStore {
    func initializeRedux()
    func suscribe(_ suscriptor: StoreSuscriptor)
    func unsuscribe(_ suscriptor: StoreSuscriptor)
    func dispatch(action: Action)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        let bounds = UIScreen.main.bounds
        let window = UIWindow(frame: bounds)
        window.makeKeyAndVisible()
        return window
    }()

    private(set) var store: Store?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        initializeRedux()
        showInitialVC()
        return true
    }
}

extension AppDelegate {

    func initializeRedux() {
        let reducer = createReducer()
        let state = createState()
        let suscriptors = createSuscriptors()
        let queue = createQueue()

        store = createStore(reducer: reducer, state: state, suscriptors: suscriptors, queue: queue)
    }

    func suscribe(_ suscriptor: StoreSuscriptor) {
        store?.suscribe(suscriptor)
    }

    func unsuscribe(_ suscriptor: StoreSuscriptor) {
        store?.unsuscribe(suscriptor)
    }

    func dispatch(action: Action) {
        store?.dispatch(action: action)
    }
}

private extension AppDelegate {

    func showInitialVC() {
        guard let state = store?.getState() as? AppState else {
            print("There is no state created")
            return
        }
        let toDoListDataSource = ToDoListDataSourceImpl(state: state)
        let toDoListVC = ToDoListVC(state: state, toDoListDataSource: toDoListDataSource, suscriber: toDoListDataSource)
        let navigationController = UINavigationController(rootViewController: toDoListVC)
        window?.rootViewController = navigationController

        initializeNavigationState()
    }

    func initializeNavigationState() {
        suscribe(self)
        let updateNavigationStateAction = UpdateNavigationStateAction()
        dispatch(action: updateNavigationStateAction)
    }

    func showList() {
        store?.replaceReducer(reducer: showToDoListReducer)
        let showListAction = ShowToDoListAction()
        dispatch(action: showListAction)
    }
}

extension AppDelegate: StoreSuscriptor {
    var identifier: String {
        let type = AppDelegate.self
        return String(describing: type)
    }

    func update(state: State) {
        unsuscribe(self)
        showList()
    }
}
