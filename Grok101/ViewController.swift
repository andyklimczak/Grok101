//
//  ViewController.swift
//  Grok101
//
//  Created by Andy Klimczak on 8/29/16.
//  Copyright © 2016 Andy Klimczak. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // GET
        Alamofire.request(TodoRouter.Get(1))
            .responseJSON { response in
                guard response.result.error == nil else {
                    print("error calling GET on /todos/2")
                    print(response.result.error!)
                    return
                }
                guard let value = response.result.value else {
                    print("no result data received")
                    return
                }
                let todo = JSON(value)
                print("the todo is: " + todo.description)
                guard let title = todo["title"].string else {
                    print("error parsing /todos/2")
                    return
                }
                print("the title is: " + title)
        }

        // POST
        let newTodo = ["title": "First Post", "completed": 0, "userId": 1]
        Alamofire.request(TodoRouter.Create(newTodo))
            .responseJSON { response in
                guard response.result.error == nil else {
                    print("error calling POST")
                    print(response.result.error!)
                    return
                }
                guard let value = response.result.value else {
                    print("no result data received")
                    return
                }
                let todo = JSON(value)
                print("The todo is: " + todo.description)
        }

        // DELETE
        Alamofire.request(TodoRouter.Delete(1))
            .responseJSON { response in
                guard response.result.error == nil else {
                    print("error calling DELETE")
                    print(response.result.error!)
                    return}
                print("DELETE ok")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

