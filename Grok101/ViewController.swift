//
//  ViewController.swift
//  Grok101
//
//  Created by Andy Klimczak on 8/29/16.
//  Copyright © 2016 Andy Klimczak. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let todoEndpoint: String = "http://jsonplaceholder.typicode.com/todos/2"
//        guard let url = NSURL(string: todoEndpoint) else {
//            print("Error: cannot create URL")
//            return
//        }
//        let urlRequest = NSURLRequest(URL: url)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) in
//            guard error == nil else {
//                print("error calling get on /todos/2")
//                print(error)
//                return
//            }
//            guard let responseData = data else {
//                print("Error: did not receive data")
//                return
//            }
//            do {
//                guard let todo = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
//                    print("error trying to convert data to JSON")
//                    return
//                }
//                print("The todo is " + todo.description)
//
//                guard let todoTitle = todo["title"] as? String else {
//                    print("COuld not get title from JSON")
//                    return
//                }
//                print("The title is: " + todoTitle)
//            } catch {
//                print("error converting data to JSON")
//                return
//            }
//
//        }
//        task.resume()
        let todosEndpoint: String = "http://jsonplaceholder.typicode.com/todos"
        guard let todosURL = NSURL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let todosUrlRequest = NSMutableURLRequest(URL: todosURL)
        todosUrlRequest.HTTPMethod = "POST"
        let newTodo = ["title": "First todo", "completed": false, "userId": 1]
        let jsonTodo: NSData
        do {
            jsonTodo = try NSJSONSerialization.dataWithJSONObject(newTodo, options: [])
            todosUrlRequest.HTTPBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let receivedTodo = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    print("Could not get JSON from responseData as dict")
                    return
                }
                print("The todo is: " + receivedTodo.description)
                guard let todoID = receivedTodo["id"] as? Int else {
                    print("Could not get TOdoID as int from JSON")
                    return
                }
                print("The ID is: \(todoID)")
            } catch {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

