//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages : [Message] = [
//        Message(sender: "1@2.com", body: "Hi"),
//        Message(sender: "a@b.com", body: "Hello"),
//        Message(sender: "1@2.com", body: "Whats up?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        loadMessages()
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }

    
    
    
    func loadMessages() {
        messages = []
        
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener() { (querySnapshot, error) in
            
            if let e = error {
                print("There was some error:\(e)")
            }
            else {
                
                self.messages = []
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messagesSender = data[K.FStore.senderField] as? String, let messageBody =
                            data[K.FStore.bodyField] as? String {
                            
                            let newMassage = Message(sender: messagesSender, body: messageBody)
                            self.messages.append(newMassage)
                            
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                let indexpath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexpath, at: .top, animated: true)
                                
                                
                            }
                            
                        }
                    }
                }
            }
            
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        
        
        messageTextfield.endEditing(true)
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField : messageSender,
                K.FStore.bodyField : messageBody,
                K.FStore.dateField : Date().timeIntervalSince1970
            ]) { (error) in
                
                if let e = error {
                    print("There is an error:\(e)")
                }
                else {
                    print("Data saved successfully")
                    
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }
            }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
          try Auth.auth().signOut()
           // Go back to Welcome screen after logout
          navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
        
    }
    
}

extension ChatViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCeelTableViewCell
        cell.label?.text = messages[indexPath.row].body
        
        
        //This is a message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messgaeBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messgaeBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        
        return cell
    }
    
    
}
