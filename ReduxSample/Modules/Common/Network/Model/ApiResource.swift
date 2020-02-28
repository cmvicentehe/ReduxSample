//
//  ApiResource.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 25/02/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

enum Method: String {

    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol ApiResource {

    var endPoint: String { get set }
    var urlComponents: URLComponents { get }
    var headers: [AnyHashable: Any]? { get }
    var bodyParameters: [AnyHashable: Any]? { get }
    var method: Method { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var timeout: TimeInterval { get }
}

// MARK: Default implementation
extension ApiResource {

    var urlComponents: URLComponents {

        var urlComponents = URLComponents()
        let scheme = Config.scheme
        let portString = Config.port ?? ""
        let port: Int? = Int(portString)
        urlComponents.scheme = scheme
        urlComponents.path = self.endPoint
        urlComponents.host = Config.hostUrl
        urlComponents.port = port
        return urlComponents
    }

    var headers: [AnyHashable: Any]? {
        
        return [ Constants.Keys.contentType:
            Constants.Keys.applicationJson]
    }
    var bodyParameters: [AnyHashable: Any]? {
        return nil
    }

    var cachePolicy: URLRequest.CachePolicy {
        return URLRequest.CachePolicy.useProtocolCachePolicy
    }

    var timeout: TimeInterval {
        return 30
    }
}
