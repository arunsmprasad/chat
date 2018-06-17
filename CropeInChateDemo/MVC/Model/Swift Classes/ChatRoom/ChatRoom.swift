//
//  ChatRoom.swift
//  CropeInChateDemo
//
//  Created by Arunprasat Selvaraj on 6/15/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import Foundation
import Firebase

//Enum
enum ChatRoomOwner {
    case sender
    case receiver
}

class ChatRoom {
    
    var ChatRoomMessage: String?
    var ChatRoomTimeStamp: Int
    var ChatRoomOwner: ChatRoomOwner
    private var ChatRoomUserID: String?
    private var ChatRoomChatUserId: String?

    init(message: String?, messageTimeStamp: Int, Owner: ChatRoomOwner){
        
        self.ChatRoomMessage = message
        self.ChatRoomTimeStamp = messageTimeStamp
        self.ChatRoomOwner = Owner
    }
    
    
    class func getAllMessages(forUserID: String, completion: @escaping (ChatRoom) -> Void) {
        
        Database.database().reference().child(USER).child(HELPER.getCurrentUserId()).child(CHAT_ROOM).child(forUserID).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                let data = snapshot.value as! [String: String]
                let aChatId = data[KEY_CHAT_ID]!
                Database.database().reference().child(CHAT_ROOM).child(aChatId).observe(.childAdded, with: { (snap) in
                    if snap.exists() {
                        
                        let receivedMessage = snap.value as! [String: Any]
                        let aTime = receivedMessage[KEY_CREATED_DATE] as! Int

                        let aMessage = receivedMessage[KEY_CHAT_MESSAGE] as! String
                        let fromID = receivedMessage[KEY_CHAT_FROM_ID] as! String
                        let timestamp = aTime
                        
                        if fromID == HELPER.getCurrentUserId() {
                           
                            let aChatRoom = ChatRoom.init(message: aMessage, messageTimeStamp: timestamp, Owner: .receiver)
                            completion(aChatRoom)
                        } else {
                            
                            let aChatRoom = ChatRoom.init(message: aMessage, messageTimeStamp: timestamp, Owner: .sender)
                            completion(aChatRoom)
                        }
                    }
                })
            }
        })
    }
    
    class func sendMessage(chatRoomValues: [String: Any], toID: String, completion: @escaping (Bool) -> Void) {
        
        Database.database().reference().child(USER).child(HELPER.getCurrentUserId()).child(CHAT_ROOM).child(toID).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists() {
                let data = snapshot.value as! [String: String]
                let aChatId = data[KEY_CHAT_ID]!
                Database.database().reference().child(CHAT_ROOM).child(aChatId).childByAutoId().setValue(chatRoomValues, withCompletionBlock: { (error, _) in
                    
                    if error == nil {
                        completion(true)
                    }
                    else {
                        completion(false)
                        
                    }
                })
            } else {
                Database.database().reference().child(CHAT_ROOM).childByAutoId().childByAutoId().setValue(chatRoomValues, withCompletionBlock: { (error, reference) in
                    let data = [KEY_CHAT_ID: reference.parent!.key]
                    Database.database().reference().child(USER).child(HELPER.getCurrentUserId()).child(CHAT_ROOM).child(toID).updateChildValues(data)
                    Database.database().reference().child(USER).child(toID).child(CHAT_ROOM).child(HELPER.getCurrentUserId()).updateChildValues(data)
                    completion(true)
                })
            }
        }
    }
}
