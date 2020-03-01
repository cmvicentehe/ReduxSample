//
//  ToDoTask.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 06/07/2019.
//  Copyright © 2019 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

enum TaskState: Int {

    case unknown = -1
    case toDo = 0
    case done = 1
}

extension TaskState: Codable {}

struct ToDoTask {
    
    let identifier: String
    let name: String
    let dueDate: Date?
    let notes: String?
    let state: TaskState

    enum CodingKeys: String, CodingKey {

        case identifier = "id"
        case name
        case dueDate
        case notes
        case state
    }

    init(identifier: String, name: String, dueDate: Date?, notes: String?, state: TaskState) {
        self.identifier = identifier
        self.name = name
        self.dueDate = dueDate
        self.notes = notes
        self.state = state
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decode(String.self, forKey: .identifier)
        name = try values.decode(String.self, forKey: .name)
        let dueDate = try values.decode(String.self, forKey: .dueDate)
        self.dueDate = CustomDateFormatter.convertDateStringToDate(dateString: dueDate,
                                                                   with: .server)
        notes = try values.decode(String.self, forKey: .notes)
        let state = try values.decode(Int.self, forKey: .state)
        self.state = TaskState(rawValue: state) ?? .unknown

    }

  func encode(to encoder: Encoder) throws {
    let dueDate = CustomDateFormatter.convertDateToString(date: self.dueDate,
                                                          with: .server)
    let state = self.state.rawValue
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(identifier, forKey: .identifier)
    try container.encode(name, forKey: .name)
    try container.encode(dueDate, forKey: .dueDate)
    try container.encode(notes, forKey: .notes)
    try container.encode(state, forKey: .state)
    }
}

extension ToDoTask: Equatable {}
extension ToDoTask: Codable {}
