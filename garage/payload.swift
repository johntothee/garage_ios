//
//  payload.swift
//  garage
//
//  Created by John Erhardt on 3/3/18.
//  Copyright © 2018 John Erhardt. All rights reserved.
//

import Foundation

struct Payload: Codable {
    let uid: Int
    let command: String
    
    func getString() -> String {
        return "uid: \(uid), command: \(command)"
    }
}
