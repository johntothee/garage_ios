//
//  ViewController.swift
//  garage
//
//  Created by John Erhardt on 2/21/18.
//  Copyright © 2018 John Erhardt. All rights reserved.
//

import UIKit
import JWT
import os.log

class ViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate {

    // MARK: Properties
    @IBOutlet weak var verify: UIButton!
    @IBOutlet weak var openClose: UIButton!
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var uidTextField: UITextField!
    @IBOutlet weak var privateKeyTextField: UITextField!
    
    private var creds: GarageCreds! = GarageCreds(
        ipAddress: "127.0.0.1",
        apiKey: "abc",
        port: 3000,
        uid: 1,
        privateKey: "abc"
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.openClose.layer.cornerRadius = 25
        self.openClose.layer.borderWidth = 1
        self.openClose.layer.borderColor = UIColor.black.cgColor
        
        self.verify.layer.cornerRadius = 10
        self.verify.layer.borderWidth = 1
        self.verify.layer.borderColor = UIColor.black.cgColor
        
        self.ipTextField.delegate = self
        self.apiKeyTextField.delegate = self
        self.portTextField.delegate = self
        self.uidTextField.delegate = self
        self.privateKeyTextField.delegate = self

        self.ipTextField.text = self.creds.ipAddress
        self.apiKeyTextField.text = self.creds.apiKey
        self.portTextField.text = String(self.creds.port)
        self.uidTextField.text = String(self.creds.uid)
        self.privateKeyTextField.text = self.creds.privateKey
        
        self.creds = self.loadGarageCreds()
        if (self.creds != nil) {
            self.ipTextField.text = self.creds.ipAddress
            self.apiKeyTextField.text = self.creds.apiKey
            self.portTextField.text = String(self.creds.port)
            self.uidTextField.text = String(self.creds.uid)
            self.privateKeyTextField.text = self.creds.privateKey
        }
        else {
            self.creds = GarageCreds(
                ipAddress: " ",
                apiKey: " ",
                port: 0,
                uid: 2,
                privateKey: " "
            )
        }

        // Do any additional setup after loading the view, typically from a nib.
        // if keys fields populated, make generateKeyPair button inactive
        if (!self.allValuesSet()) {
            verify.isEnabled = false
        }
        
        // @TODO: test if verify is completed, and disable openClose if not.
        //openClose.isEnabled = false
 
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
        sendToken("verify")
    }
    
    // Send an open-close command.
    @IBAction func openClose(_ sender: UIButton) {
        sendToken("open-close")
    }
    
    // Create a Jwt token.
    func signJwtToken(_ command: String) {
    }
    
    // Send token to server.
    func sendToken(_ token: String) {
        let headers:[String:Any] = ["alg":"RS256","typ":"jwt"]
        var urlResponse:NSString = ""

        do {
            let timestamp = Int64(NSDate().timeIntervalSince1970)
            let payload:[String:Any] = ["uid":self.creds.uid,"command":token,"iat":timestamp]

            let privateKey = try JWTCryptoKeyPrivate(pemEncoded: self.creds.privateKey, parameters: nil)

            guard let holder = JWTAlgorithmRSFamilyDataHolder().signKey(privateKey)?.secretData(Data())?.algorithmName(JWTAlgorithmNameRS256) else {
                    print("cannot make holder")
                    return
                }
            guard let encoding = JWTEncodingBuilder.encodePayload(payload).headers(headers)?.addHolder(holder) else {
                print("cannot make endcoding")
                return
            }
            let result = encoding.result
            print(result?.successResult?.encoded ?? "Encoding failed")
            print(result?.errorResult?.error ?? "No encoding error")
            var url = "https://"
            url += self.creds.ipAddress
            url += ":"
            url += String(self.creds.port)
            url += "/api/garage?apikey="
            url += self.creds.apiKey
            url += "&token="
            url += (result?.successResult?.encoded)!
            var urlObject = URL(string: url )
            
            let task = URLSession.shared.dataTask(with: urlObject!) {(data, response, error) in
                print("response string:")
                if (data != nil) {
                    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                    urlResponse = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                    self.verifySuccess(String(urlResponse))
                }
                else {
                    self.verifySuccess("No response from garage!")
                }

            }
            
            task.resume()
        }
        catch {
            print(error)
        }
        print("Here is the response:")
        print(urlResponse)
    }
    
    // Alert that verify command worked
    private func verifySuccess(_ response: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Received from garage:", message: response, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            if (response == "No response from garage!") {
                alert.addAction(UIAlertAction(title: "Try Again?", style: .cancel, handler: nil))
            }
            self.present(alert, animated: true)
        }
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
        if (privateKeyTextField.text == "") {
            return false
        }
        return true
    }
    
    private func loadGarageCreds() -> GarageCreds?  {
        guard let results = NSKeyedUnarchiver.unarchiveObject(withFile: GarageCreds.ArchiveURL.path) as? GarageCreds else {
            os_log("Unable to load GarageCreds from storage.", log: OSLog.default, type: .debug)
            return nil
        }
        return results
    }
    
    private func save() {
        if !self.allValuesSet() {
            return
        }
        self.creds.ipAddress = ipTextField.text!
        self.creds.apiKey = apiKeyTextField.text!
        self.creds.port = Int(portTextField.text!)!
        self.creds.uid = Int(uidTextField.text!)!
        self.creds.privateKey = privateKeyTextField.text!
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.creds, toFile: GarageCreds.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Creds successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save creds...", log: OSLog.default, type: .error)
        }
    }
}




