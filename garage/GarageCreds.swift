//
//  GarageCreds.swift
//  garage
//
//  Created by John Erhardt on 3/4/18.
//  Copyright © 2018 John Erhardt. All rights reserved.
//
// Credentials to access and command. This info needs to be stored.


import UIKit
import os.log

class GarageCreds: NSObject, NSCoding {
    
    //MARK: Properties
    var ipAddress: String
    var apiKey: String
    var port: Int
    var uid: Int
    var privateKey: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("garageCreds")

    //MARK: Types
    struct PropertyKey {
        static let ipAddress = "ipAddress"
        static let apiKey = "apiKey"
        static let port = "port"
        static let uid = "uid"
        static let privateKey = "privateKey"
    }
    
    //MARK: Initialization
    init(ipAddress: String, apiKey: String, port: Int, uid: Int, privateKey: String) {
        self.ipAddress = ipAddress
        self.apiKey = apiKey
        self.port = port
        self.uid = uid
        self.privateKey = privateKey
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ipAddress, forKey: PropertyKey.ipAddress)
        aCoder.encode(self.apiKey, forKey: PropertyKey.apiKey)
        aCoder.encodeCInt(Int32(self.port), forKey: PropertyKey.port)
        aCoder.encodeCInt(Int32(self.uid), forKey: PropertyKey.uid)
        aCoder.encode(self.privateKey, forKey: PropertyKey.privateKey)

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let ipAddress = aDecoder.decodeObject(forKey: PropertyKey.ipAddress) as? String else {
            os_log("Unable to decode the ipAddress for garageCreds Object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let uid = aDecoder.decodeInteger(forKey: PropertyKey.uid) as? Int else {
            os_log("Unable to decode the uid for garageCreds object.", log: OSLog.default, type: .debug)
            return nil
        }

        guard let apiKey = aDecoder.decodeObject(forKey: PropertyKey.apiKey) as? String else {
            os_log("Unable to decode the apiKey for garageCreds Object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let port = aDecoder.decodeInteger(forKey: PropertyKey.port) as? Int else {
            os_log("Unable to decode the port for garageCreds Object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let privateKey = aDecoder.decodeObject(forKey: PropertyKey.privateKey) as? String else {
            os_log("Unable to decode the privateKey for garageCreds Object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(ipAddress: ipAddress, apiKey: apiKey, port: port, uid: uid, privateKey: privateKey)
    }
    
}

