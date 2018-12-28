//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import  ChameleonFramework
// if you use the table, inserted the following
// UITableViewDelegate -> this responsible to tell the ChatView when something is clicked
// UITableViewDataSouce -> this is responsible for the data
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate{
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]() //declare new and empty array of messages
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self

        
        
        //TODO: Set the tapGesture here:
         //this is used to call the function of end of editing the text field whenever a tap on the table view occurs
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        

        //TODO: Register your MessageCell.xib file here:
        // To be able to access the custom cell we have to register it
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retriveMessages()
        messageTableView.separatorStyle = .none
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // to use the custom cell created
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        
        // output the cell to display in the tableView
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg") //default avatar image
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            //message we sent
            
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }
        
        else
        {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            
        }
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //the number of cells
        return messageArray.count
    }
    
    
    //TODO: Declare tableViewTapped here:
    
    @objc func tableViewTapped() {
        //this is used to call the function of end of editing the text field whenever a tap on the table view occurs
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    
    // this function is to show the whole content of the cell in the chat, without it the text will not be shown perfictly
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0 //this is estimated hieght, the above line will fix the height
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        
        //TODO: Send the message to Firebase and save it in our database
        
        //temporarly disable the items, to be able to process and save the text
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        //saving the message to the database
        
        //create a new child database inside the main database
        let messagesDB = Database.database().reference().child("Messages")
        //the sender is the current user using the app, and the message is the text in the message field
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text]
        
        //save the dictionary to the message DB
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            if error != nil {
                print (error!)
                
            }
            else {
                print("Message saved successfully!")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retriveMessages(){
        //you have to use the same DB for sending and recieving
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            
            //get the data from the "snapshot" and customize them
            //Dictionary<key type:value type>
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            //create new message object
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            //add it to the message array
            
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
            

        }
        
    }

    

    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        // sign out method in Firebase ( you have to use a try catch in order to get rid off errors )
        
        do {
        try  Auth.auth().signOut()
            // After signing out, to get the user from chatViewController to Root (Main page) 
            navigationController?.popToRootViewController(animated: true)
            
        } catch {
            
            print(" error, therer was a problem signing out." )
        }
        
    }
    


}
