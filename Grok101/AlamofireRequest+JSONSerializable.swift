//
//  AlamofireRequest+JSONSerializable.swift
//  Grok101
//
//  Created by Andy Klimczak on 8/29/16.
//  Copyright © 2016 Andy Klimczak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension Alamofire.Request {
    public func responseObject<T: ResponseJSONObjectSerializable>(completionHandler:
        Response<T, NSError> -> Void) -> Self {
        let serializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            guard let responseData = data else {
                let failureReason = "Object could not be serialized because input was nil"
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }

            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)

            switch result {
            case .Failure(let error):
                return .Failure(error)
            case .Success(let value):
                let json = SwiftyJSON.JSON(value)
                guard let object = T(json: json) else {
                    let failureReason = "Object could not be created from JSON"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
                return .Success(object)
            }
        }
        return response(responseSerializer: serializer, completionHandler: completionHandler)
    }
}