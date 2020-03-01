//
//  NetworkClient.swift
//  ReduxSample
//
//  Created by Carlos Manuel Vicente Herrero on 25/02/2020.
//  Copyright © 2020 Carlos Manuel Vicente Herrero. All rights reserved.
//

import Foundation

protocol NetworkClient {
    func performRequest<T: Decodable>(for resource: ApiResource, type: T.Type?, completion: @escaping (Result<T?, Error>) -> Void)
}

struct NetworkClientImpl {

    let urlSession: URLSession
    init(urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.urlSession = urlSession
    }
}

extension NetworkClientImpl: NetworkClient {

    func performRequest<T: Decodable>(for resource: ApiResource, type: T.Type?, completion: @escaping (Result<T?, Error>) -> Void) {

        guard let urlRequest = buildURLRequest(from: resource) else {
            print("Invalid url Request")
            return
        }

        urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            guard let responseNotNil = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            let status = self.status(from: responseNotNil.statusCode)
            let urlResponse = Response(status: status,
                                       url: responseNotNil.url,
                                       data: data,
                                       error: error)

            let result = self.process(response: urlResponse, type: type)

            completion(result)
        }).resume()
    }
}

private extension NetworkClientImpl {
    
    func buildURLRequest(from resource: ApiResource) -> URLRequest? {

        guard let url = resource.urlComponents.url else {
            print("Invalid url from components")
            return nil
        }

        let bodyParameters = resource.bodyParameters ?? [:]
        let headers = resource.headers as? [String: String] ?? [:]
        let httpMethod = resource.method.rawValue
        let jsonData = (bodyParameters.count > 0) ?
            try? JSONSerialization.data(withJSONObject: bodyParameters,
                                        options: .prettyPrinted) : nil

        var request = URLRequest(
            url: url,
            cachePolicy: resource.cachePolicy,
            timeoutInterval: resource.timeout)

        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod
        request.httpBody = jsonData

        print("URL --> \(url)")
        print("Headers --> \(headers)")
        print("Method --> \(httpMethod)")
        print("Body --> \(bodyParameters)")

        return request
    }

    func status(from statusCode: Int) -> Status {

        var status: Status = .unknown
        switch statusCode {
        case 100...199:
            status = .info(statusCode)
        case 200...299:
            status = .success(statusCode)
        case 300...399:
            status = .redirection(statusCode)
        case 400...499:
            status = .clientError(statusCode)
        case 500...599:
            status = .serverError(statusCode)
        default:
            status = .unknown
        }
        return status
    }

    func process<T: Decodable>(response: Response, type: T.Type?) -> Result<T?, Error> {

        let status = response.status
        print("Http status -->\(status)")
        switch status {
        case .success:
            return buildSuccessResult(type: type, data: response.data)
        case .info, .redirection:
            return buildSuccessResult(type: type, data: response.data)
        case .clientError, .serverError:
            let error = response.error ?? NSError(domain: "ReduxSample",
                                                  code: -1,
                                                  userInfo: [:])

            if let dataNotNil = response.data {
                let responseString = String(data: dataNotNil,
                                            encoding: .utf8) ?? ""
                print("Response --> \(responseString)")
                print("Error --> \(error)")
            }
            return .failure(error)
        default:
            return .success(nil)
        }
    }

    func buildSuccessResult<T: Decodable>(type: T.Type?, data: Data?) -> Result<T?, Error> {

        guard let typeNotNil = type,
            let dataNotNil = data else {
            return .success(nil)
        }

        let responseString = String(data: dataNotNil,
                                    encoding: .utf8) ?? ""
        print("Response --> \(responseString)")

        do {
            let value = try JSONDecoder().decode(typeNotNil, from: dataNotNil)
            return .success(value)
        } catch let error {
            return .failure(error)
        }
    }

}
