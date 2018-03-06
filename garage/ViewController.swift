//
//  ViewController.swift
//  garage
//
//  Created by John Erhardt on 2/21/18.
//  Copyright © 2018 John Erhardt. All rights reserved.
//

import UIKit
import JWTCocoapods
import JSONCocoapods
import os.log


class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var verify: UIButton!
    @IBOutlet weak var openClose: UIButton!
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var uidTextField: UITextField!
    @IBOutlet weak var publicKeyTextField: UITextField!
    @IBOutlet weak var privateKeyTextField: UITextField!
    
    private var creds: GarageCreds! = GarageCreds(ipAddress: "127.0.0.1", apiKey: "abc", port: 3000, uid: 1, publicKey: "insert public Key here", privateKey: "abc")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ipTextField.delegate = self
        self.apiKeyTextField.delegate = self
        self.portTextField.delegate = self
        self.uidTextField.delegate = self
        self.publicKeyTextField.delegate = self
        self.privateKeyTextField.delegate = self

        self.ipTextField.text = self.creds.ipAddress
        self.apiKeyTextField.text = self.creds.apiKey
        self.portTextField.text = String(self.creds.port)
        self.uidTextField.text = String(self.creds.uid)
        self.publicKeyTextField.text = self.creds.publicKey
        self.privateKeyTextField.text = self.creds.privateKey
        
        self.creds = self.loadGarageCreds()
        if (self.creds != nil) {
            self.ipTextField.text = self.creds.ipAddress
            self.apiKeyTextField.text = self.creds.apiKey
            self.portTextField.text = String(self.creds.port)
            self.uidTextField.text = String(self.creds.uid)
            self.publicKeyTextField.text = self.creds.publicKey
            self.privateKeyTextField.text = self.creds.privateKey
        }
        else {
            self.creds = GarageCreds(ipAddress: " ", apiKey: " ", port: 0, uid: 2, publicKey: " ", privateKey: " ")
        }

        // Do any additional setup after loading the view, typically from a nib.
        // if keys fields populated, make generateKeyPair button inactive
        if (!self.allValuesSet()) {
            verify.isEnabled = false
        }
        
        // @TODO: test if verify is completed, and disable openClose if not.
        openClose.isEnabled = false
        
        //testing
        let payload = Payload(uid: 1, command: "open-close")
        let test = String(describing: try? payload.makeJSON())
        print(test)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // This is only when completing text entry with Enter key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.save()
        if (self.allValuesSet()) {
            verify.isEnabled = true
        }
        else {
            verify.isEnabled = false
        }
        return true
    }
    
    // When done editing test if verify button should be enabled/disabled.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.save()
        if (self.allValuesSet()) {
            verify.isEnabled = true
        }
        else {
            verify.isEnabled = false
        }
        return true
    }
    
    // MARK: Actions
    // Send a verify command.
    @IBAction func verify(_ sender: UIButton) {
        
    }
    
    // Send an open-close command.
    @IBAction func openClose(_ sender: UIButton) {
    }
    
    // Create a Jwt token.
    func signJwtToken(_ command: String) {
    }
    
    // Send token to server.
    func sendToken(_ token: String) {
        //let frameworkObject = JWT.init()
    }
    
    // Test if all values are set
    private func allValuesSet() -> Bool {
        if (ipTextField.text == "") {
            return false
        }
        if (apiKeyTextField.text == "") {
            return false
        }
        if (portTextField.text == "") {
            return false
        }
        if (uidTextField.text == "") {
            return false
        }
        if (publicKeyTextField.text == "") {
            return false
        }
        if (privateKeyTextField.text == "") {
            return false
        }
        return true
    }
    
    private func loadGarageCreds() -> GarageCreds!  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: GarageCreds.ArchiveURL.path) as? GarageCreds
    }
    
    private func save() {
//        if !self.allValuesSet() {
//            return
//        }
        creds.ipAddress = ipTextField.text!
        creds.apiKey = apiKeyTextField.text!
        creds.port = Int(portTextField.text!)!
        creds.uid = Int(uidTextField.text!)!
        creds.publicKey = publicKeyTextField.text!
        creds.privateKey = privateKeyTextField.text!
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(creds, toFile: GarageCreds.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Creds successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save creds...", log: OSLog.default, type: .error)
        }
    }
    

}




