//
//  Decoder.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 05/03/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

protocol ResponseDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
    func object(with data: Data) throws -> Any
}
