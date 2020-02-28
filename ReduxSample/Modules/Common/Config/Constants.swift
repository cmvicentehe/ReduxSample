//
//  Constants.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 25/02/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct Constants {

    struct Services {

        struct Endpoints {

            static let tasks = "/tasks"
            static let newTask = "/send"
            static let updateTask = "/update"
            static let deleteTask = "/delete/{{taskId}}"
            static let taskIdPlaceholder = "{{taskId}}"
        }
    }

    struct Keys {

        static let scheme = "SCHEME"
        static let hostUrl = "HOST_URL"
        static let port = "PORT"
        static let contentType = "Content-Type"
        static let applicationJson = "application/json"
        static let identifier = "id"
        static let name = "name"
        static let dueDate = "dueDate"
        static let notes = "notes"
        static let state = "state"
    }
}
