//
//  payload.swift
//  garage
//
//  Created by John Erhardt on 3/3/18.
//  Copyright © 2018 John Erhardt. All rights reserved.
//

import Foundation
import JSONCocoapods

class Payload {
    
    //Add your properties like you normally would in iOS
    var uid: Int
    var command: String
    
    //Convinience method for instanciation of our object
    init(uid: Int, command: String) {
        self.uid = uid
        self.command = command
    }
}

extension Payload: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("uid", uid)
        try json.set("command", command)
        return json
    }
}
