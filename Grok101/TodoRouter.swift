//
//  TodoRouter.swift
//  Grok101
//
//  Created by Andy Klimczak on 8/29/16.
//  Copyright © 2016 Andy Klimczak. All rights reserved.
//

import Foundation
import Alamofire

enum TodoRouter: URLRequestConvertible {
    static let baseURLString = "http://jsonplaceholder.typicode.com/"

    case Get(Int)
    case Create([String: AnyObject])
    case Delete(Int)

    var URLRequest: NSMutableURLRequest {
        var method: Alamofire.Method {
            switch self {
            case .Get:
                return .GET
            case .Create:
                return .POST
            case .Delete:
                return .DELETE
            }
        }
        let params: ([String: AnyObject]?) = {
            switch self {
            case .Get, .Delete:
                return nil
            case .Create(let newTodo):
                return (newTodo)
            }
        }()

        let url:NSURL = {
            let relativePath:String?
            switch self {
            case .Get(let number):
                relativePath = "todos/\(number)"
            case .Create:
                relativePath = "todos"
            case .Delete(let number):
                relativePath = "todos/\(number)"
            }
            var URL = NSURL(string: TodoRouter.baseURLString)!
            if let relativePath = relativePath {
                URL = URL.URLByAppendingPathComponent(relativePath)
            }
            return URL
        }()
        let URLRequest = NSMutableURLRequest(URL: url)
        let encoding = Alamofire.ParameterEncoding.JSON
        let (encodedRequest, _) = encoding.encode(URLRequest, parameters: params)
        encodedRequest.HTTPMethod = method.rawValue
        return encodedRequest
    }
}