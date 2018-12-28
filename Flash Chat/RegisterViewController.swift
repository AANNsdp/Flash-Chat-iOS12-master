//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: - User registeration and Authentication
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        //Set up a new user on our Firbase database
        // Firebase Authentication for user and password
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!)  { (user, error) in
            //check if the user was created
            if error != nil {
                print("error")
            } else {
                //sucessfull registeration ( find the user in Firebase -> Authentication -> Users)
                
                print("registeration sucessful")
                SVProgressHUD.dismiss()
                
                // To move from the registeration page to the Chat page
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }

        
        
    } 
    
    
}
