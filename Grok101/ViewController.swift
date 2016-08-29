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

    override func viewDidLoad() {
        super.viewDidLoad()
        let todoEndpoint: String = "http://jsonplaceholder.typicode.com/todos/2"
        Alamofire.request(.GET, todoEndpoint)
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
            .responseString{ response in
                print(response.result.value)
                print(response.result.error)
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

