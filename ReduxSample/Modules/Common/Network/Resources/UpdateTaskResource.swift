//
//  UpdateTaskResource.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 26/02/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct UpdateTaskResource {

    let identifier: String
    let name: String
    let dueDate: Date?
    let notes: String?
    let state: Int

    var endPoint: String
}

extension UpdateTaskResource: ApiResource {

    var method: Method {
        return .patch
    }

    var bodyParameters: [AnyHashable: Any]? {

        var bodyParameters: [AnyHashable: Any] = [Constants.Keys.identifier: identifier,
                                                  Constants.Keys.name: name,
                                                  Constants.Keys.state: state]

        if let notesNotNil = notes {
            bodyParameters[Constants.Keys.notes] = notesNotNil
        }

        let date = CustomDateFormatter.convertDateToString(date: dueDate, with: .default)
        bodyParameters[Constants.Keys.dueDate] = date ?? "--"

        return bodyParameters
    }
}
