//
//  DeleteTaskResource.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 26/02/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct DeleteTaskResource {
    var endPoint: String
}

extension DeleteTaskResource: ApiResource {

    var method: Method {
        return .delete
    }
}
