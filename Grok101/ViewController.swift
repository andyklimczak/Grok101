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
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // get todo #1
        Todo.todoByID(1) { result in
            if let error = result.error {
                print("error calling GET")
                print(error)
                return
            }
            guard let todo = result.value else {
                print("error calling GET")
                return
            }
            print("GET todo")
            print(todo.description())
            print(todo.title)
        }
        // create todo
        guard let newTodo = Todo(aTitle: "First todo",
        anId: nil,
        aUserId: 1,
        aCompletedStatus: true) else {
            print("error: new todo isn't a todo")
            return
        }
        newTodo.save { result in
            guard result.error == nil else {
                print("error calling PST on todos")
                print(result.error)
                return
            }
            guard let todo = result.value else {
                print("error calling POST on todos")
                return
            }
            print("CREATE todo")
            print(todo.description())
            print(todo.title)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}