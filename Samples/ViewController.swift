//
//  ViewController.swift
//  TestTwitterLogin
//
//  Created by Huang on 2022/10/24.
//

import UIKit

import TwitterSignIn


class ViewController: UIViewController {

    @IBOutlet weak var _outputText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TwitterSignIn.sharedInstance.consumerKey = "your value"
        TwitterSignIn.sharedInstance.consumerSecret = "your value"
        TwitterSignIn.sharedInstance.callbackUrl = "your value"
        print("[Simples] set config")
        
    }

    

    @IBAction func onSignInWithTwitter(_ sender: Any) {
        print("[Simples] SignIn to Twitter...")
        TwitterSignIn.sharedInstance.appAuthEnable = true
        
        TwitterSignIn.sharedInstance.signIn { user, error in
            let timeStr = Date().description(with: .current)
            if let error = error {
                let outputStr = "\(timeStr)\nTwitter SignIn Failed!\n \(error.description)"
                DispatchQueue.main.async {
                    self._outputText.text = outputStr
                }
                print("[Simples] \(outputStr)")
                return
            }
            
            if let user = user {
                let outputStr = "\(timeStr)\nTwitter SignIn Success!\ntoken=\(user.token)\nsecret=\(user.secret)\nuserId=\(user.userId)\nuserName=\(user.userName)"
                DispatchQueue.main.async {
                    self._outputText.text = outputStr
                }
                print("[Simples] \(outputStr)")
            }
        }
        
    }
}
