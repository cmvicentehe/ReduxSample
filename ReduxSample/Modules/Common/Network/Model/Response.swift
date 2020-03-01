//
//  Response.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 25/02/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

 enum Status {

    case info (Int)
    case success (Int)
    case clientError (Int)
    case redirection (Int)
    case serverError (Int)
    case unknown
}

struct Response {
    
    let status: Status
    let url: URL?
    let data: Data?
    let error: Error?
}
