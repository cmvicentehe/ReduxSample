//
//  Config.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 25/02/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

struct Config {
    
    static let scheme: String = Bundle.main.object(forInfoDictionaryKey: Constants.Keys.scheme) as? String ?? ""
    static let hostUrl: String = Bundle.main.object(forInfoDictionaryKey: Constants.Keys.hostUrl) as? String ?? ""
    static let port: String? = Bundle.main.object(forInfoDictionaryKey: Constants.Keys.port) as? String
}
