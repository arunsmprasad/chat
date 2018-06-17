//
//  ChatViewController.swift
//  CropeInChateDemo
//
//  Created by Arunprasat Selvaraj on 6/15/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import UIKit
import Firebase

class chatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gLeftView: UIView!
    @IBOutlet weak var gRightView: UIView!
    @IBOutlet weak var gRightLabel: UILabel!
    @IBOutlet weak var gLeftLabel: UILabel!
    @IBOutlet weak var gRightTimeLabel: UILabel!
    @IBOutlet weak var gleftTimeLabel: UILabel!
}

class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var mySendButton: UIButton!
    
    @IBOutlet weak var myTextViewBottomConstraints: NSLayoutConstraint!
    var gNameString: String!
    var gChatUserId: String!
    var myDataBaseRef: DatabaseReference!
    var myChatArray = [ChatRoom]()
    var myChatKeyString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupModel()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        setNavigationBar()
        HELPER.roundCorner(for: myTextView, radius: 8, borderColor: UIColor.lightGray)
        HELPER.roundCorner(for: mySendButton, radius: 4, borderColor: UIColor.clear)
        
        mySendButton.isUserInteractionEnabled = false
    }
    
    func setupModel() {
        
        myTableView.separatorInset = UIEdgeInsetsMake(2, 2, 0, 2)
        myTableView.tableFooterView = UIView()
        
        getChatMessages()// Get all messages between the current user
    }
    
    //MARK: UIButton Methode
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2) {
            
            self.myTextViewBottomConstraints.constant = 4
            self.myTextView.resignFirstResponder()
        }
        addChatInfo()
    }
    
    @objc func leftBarButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helper
    
    func setNavigationBar() {
        
        UINavigationController().setNavigationBarTitle(title: gNameString , viewController: self)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_back"), style: .plain, target: self, action: #selector(leftBarButtonTapped))
    }
    
    func getChatMessages() {
        
        ChatRoom.getAllMessages(forUserID: gChatUserId) {[weak weakSelf = self] (chatRoom) in
            
            weakSelf?.myChatArray.append(chatRoom)
            weakSelf?.myChatArray.sort{ $0.ChatRoomTimeStamp < $1.ChatRoomTimeStamp }
            
            DispatchQueue.main.async {
                
                if let state = weakSelf?.myChatArray.isEmpty, state == false {
                    
                    weakSelf?.myTableView.reloadData()
                    weakSelf?.myTableView.scrollToRow(at: IndexPath.init(row: (weakSelf?.myChatArray.count)! - 1, section: 0), at: .bottom, animated: false)
                }
            }
        }
    }
    
    func addChatInfo() {
        
        let aTimeStlamp = Int(Date().timeIntervalSince1970)
        
        let chatInfo: [String: Any] = [
            KEY_CHAT_MESSAGE:myTextView.text,
            KEY_CREATED_DATE: Int(aTimeStlamp),
            KEY_CHAT_TO_ID: gChatUserId,
            KEY_CHAT_USER_NAME: gNameString,
            KEY_CHAT_FROM_ID: HELPER.getCurrentUserId()
        ]
        
        ChatRoom.sendMessage(chatRoomValues: chatInfo, toID: gChatUserId) { (_) in
        
            self.myTextView.text = ""
            self.mySendButton.isUserInteractionEnabled = false
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            return false
        }
        
        let currenttext = textView.text as NSString?
        
        let aText = currenttext?.replacingCharacters(in: range, with: text)
        let aStr = aText?.replacingOccurrences(of: " ", with: "")
        
        if ((aStr?.count) != 0) {
            
            mySendButton.isUserInteractionEnabled = true
        }
        else {
            
            mySendButton.isUserInteractionEnabled = false
        }
        myTextViewHeightConstraint.constant = ( textView.contentSize.height > 150) ? 150 : textView.contentSize.height
        
        return  true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
    
        UIView.animate(withDuration: 0.2) {
            
            if UIScreen.main.nativeBounds.height > 2400 {
                self.myTextViewBottomConstraints.constant = 300
            }
            else {
                self.myTextViewBottomConstraints.constant = 250
            }
        }
    }
}

extension ChatViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.2) {
            
            self.myTextViewBottomConstraints.constant = 4
            self.myTextView.resignFirstResponder()
        }
    }
}
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myChatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var aCell: chatTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "chatTableViewCell") as? chatTableViewCell
        
        if aCell == nil {
            
            aCell = UITableViewCell.init(style: .default, reuseIdentifier: "chatTableViewCell") as? chatTableViewCell
        }
        let aChatUserModel = myChatArray[indexPath.row]
        HELPER.roundCorner(for: (aCell?.gRightView)!, radius: 8, borderColor: UIColor.clear)
        HELPER.roundCorner(for: (aCell?.gLeftView)!, radius: 8, borderColor: UIColor.clear)
        
        if aChatUserModel.ChatRoomOwner == .sender {
            
            aCell?.gRightView.isHidden = true
            aCell?.gLeftView.isHidden = false
            
            aCell?.gLeftLabel.text = aChatUserModel.ChatRoomMessage
            
            //Convert TimeInterval into date
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(aChatUserModel.ChatRoomTimeStamp))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            aCell?.gleftTimeLabel.text = date

        }
        else {
            
            aCell?.gRightView.isHidden = false
            aCell?.gLeftView.isHidden = true
            
            aCell?.gRightLabel.text = aChatUserModel.ChatRoomMessage
            
            //Convert TimeInterval into date
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(aChatUserModel.ChatRoomTimeStamp))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            aCell?.gRightTimeLabel.text = date
        }
        
        return aCell!
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        UIView.animate(withDuration: 0.2) {
            
            self.myTextViewBottomConstraints.constant = 4
            self.myTextView.resignFirstResponder()
        }
    }
}

