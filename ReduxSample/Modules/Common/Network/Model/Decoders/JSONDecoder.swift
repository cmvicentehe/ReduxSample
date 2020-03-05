//
//  JSONDecoder.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 05/03/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct CustomJSONDecoder {
    
    let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
}

extension CustomJSONDecoder: ResponseDecoder {
    
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try decoder.decode(type,
                                  from: data)
    }
    
    func object(with data: Data) throws -> Any {
        return try JSONSerialization.jsonObject(with: data,
                                                options: .allowFragments)
    }
}
