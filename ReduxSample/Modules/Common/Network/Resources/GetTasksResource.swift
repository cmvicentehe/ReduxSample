//
//  GetTasksResource.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 25/02/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct GetTasksResource {
    var endPoint: String
}

extension GetTasksResource: ApiResource {
    
    var method: Method {
        return .get
    }
}
