//
//  ToDoViewModel.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 28/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

class ToDoViewModel {

    let taskIdentifier: String
    let title: String
    let date: String?
    let notes: String?
    let isSelected: Bool
    var detailUpdater: DetailUpdater?

    init(taskIdentifier: String, title: String, date: String?, notes: String?, isSelected: Bool) {

        self.taskIdentifier = taskIdentifier
        self.title = title
        self.date = date
        self.notes = notes
        self.isSelected = isSelected
    }
}

extension ToDoViewModel: StoreSuscriptor {

    var identifier: String {

        let type = ToDoViewModel.self
        return String(describing: type)
    }

    func update(state: State) {

        guard let appState = state as? AppState else {
            print("There is no a valid state")
            return
        }

        detailUpdater?.update(with: appState)
    }
}

extension ToDoViewModel: Suscriber {

    func suscribe() {

        guard let appDelegate = AppDelegateUtils.appDelegate else {
            return
        }

        appDelegate.suscribe(self)
    }

    func unsuscribe() {
        
        guard let appDelegate = AppDelegateUtils.appDelegate else {
            return
        }

        appDelegate.unsuscribe(self)
    }
}
