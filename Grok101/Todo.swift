//
//  Todo.swift
//  Grok101
//
//  Created by Andy Klimczak on 8/29/16.
//  Copyright © 2016 Andy Klimczak. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public protocol ResponseJSONObjectSerializable {
    init?(json: SwiftyJSON.JSON)
}

class Todo: ResponseJSONObjectSerializable {
    var title: String?
    var id: Int?
    var userId: Int?
    var completed: Bool?

    required init?(aTitle: String?, anId: Int?, aUserId: Int?, aCompletedStatus: Bool?) {
        self.title = aTitle
        self.id = anId
        self.userId = aUserId
        self.completed = aCompletedStatus
    }

    required init?(json: SwiftyJSON.JSON) {
        self.title = json["title"].string
        self.id = json["id"].int
        self.userId = json["userId"].int
        self.completed = json["completed"].bool
    }

    func description() -> String {
        return "ID: \(self.id)" +
        "User ID: \(self.userId)" +
        "Title: \(self.title)\n" +
        "Completed: \(self.completed)\n"
    }

    class func todoByID(id: Int, completionHandler: (Result<Todo, NSError>) -> Void) {
        Alamofire.request(TodoRouter.Get(id))
            .responseObject { (response: Response<Todo, NSError>) in
                completionHandler(response.result)
        }
    }

    func toJSON() -> [String: AnyObject] {
        var json = [String: AnyObject]()
        if let title = title {
            json["title"] = title
        }
        if let id = id {
            json["id"] = id
        }
        if let userId = userId {
            json["userId"] = userId
        }
        if let completed = completed {
            json["completed"] = completed
        }
        return json
    }

    func save(completionHandler: (Result<Todo, NSError>) -> Void) {
        let fields = self.toJSON()
        Alamofire.request(TodoRouter.Create(fields))
            .responseObject { (response: Response<Todo, NSError>) in
                completionHandler(response.result)
        }
    }
}