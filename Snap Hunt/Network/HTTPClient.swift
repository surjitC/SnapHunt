//
//  HTTPClient.swift
//  Quick Hunt
//
//  Created by Surjit Chowdhary on 18/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import Foundation

//APPError enum which shows all possible errors
public enum APPError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

//Result enum to show success or failure
public enum CustomResult<T> {
    case success(T)
    case failure(APPError)
}

/// Server request Methods
public enum RequestMethod: String {
    case GET
    case POST
    case UPLOAD
    case DELETE
    case PUT
}


class HTTPClient {

    static let shared = HTTPClient()

    //dataRequest which sends request to given URL and convert to Decodable Object
    func dataRequest<T: Decodable>(with url: String, method: RequestMethod, requestBody: Data?, objectType: T.Type, completion: @escaping (CustomResult<T>) -> Void) {

        //create the url with NSURL
        let dataURL = URL(string: url)! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        var request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.httpMethod = method.rawValue

        //adding headers
        request.addValue(StringConstant.applicationJson, forHTTPHeaderField: StringConstant.accept)
        request.addValue(StringConstant.applicationJson, forHTTPHeaderField: StringConstant.contentType)
        request.addValue(NetworkManager.hostName, forHTTPHeaderField: StringConstant.host)
        let authorizationString = getAuthorizationString(value: NetworkManager.authorizationKey)
        request.addValue(authorizationString, forHTTPHeaderField: StringConstant.authorization)

        request.httpBody = requestBody //try? encoder.encode(query)
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(CustomResult.failure(.networkError(error!)))
                return
            }
            guard let data = data else {
                completion(CustomResult.failure(.dataNotFound))
                return
            }

            do {
                //create decodable object from data
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(CustomResult.success(decodedObject))
            } catch let error {
                if let err = error as? DecodingError {
                    completion(CustomResult.failure(.jsonParsingError(err)))
                }
            }
        })

        task.resume()
    }

    func getAuthorizationString(value: String) -> String {
        return "Bearer \(value)"
    }
    
}
