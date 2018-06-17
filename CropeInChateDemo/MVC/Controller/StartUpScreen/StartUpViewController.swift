//
//  StartUpViewController.swift
//  CropeInChateDemo
//
//  Created by Arunprasat Selvaraj on 6/15/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import UIKit
import Firebase

class StartUpViewController: UIViewController {
    
    @IBOutlet weak var myTextfield: UITextField!
    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var myRegisterScreen: UIButton!
    @IBOutlet weak var myLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func setupUI() {
     
        UINavigationController().setNavigationBarTitle(title: SCREEN_TITLE_LOGIN , viewController: self)
    }
    
    func setupModel() {
        
    }
    
    //MARK: UIButton Action
    
    @IBAction func RegisterButtonTapped(_ sender: Any) {
        
        if (myTextfield.text?.isEmpty)! {
            
            UIAlertController().showAlertViewWithOkAction(self, title: "", message: ALERT_ADD_CURRENT_USER, okButtonBlock: { (_ action : UIAlertAction) in
                
            })
        }
        else {
            
            checkingForResgister()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    
        if (myTextfield.text?.isEmpty)! {
            
            UIAlertController().showAlertViewWithOkAction(self, title: "", message: ALERT_ADD_CURRENT_USER, okButtonBlock: { (_ action : UIAlertAction) in
                
            })
        }
        else {
        
            checkingForLogin()
        }
    }
    
    //MARK: Helper
    
    func checkingForLogin() {
        // The user name is checked with the value in Firebase
        Database.database().reference().child(USER).queryOrdered(byChild:KEY_USER_NAME).queryEqual(toValue: myTextfield.text).observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() == false {
                
                UIAlertController().showAlertViewWithOkAction(self, title: "", message: ALERT_NOT_EXISTING_USER, okButtonBlock: { (_ action : UIAlertAction) in
                    
                })
            }
            else{
                
                for item in snapshot.children {
                  
                    let fetchedUserSnapshot = item as! DataSnapshot
                  
                    if let fetchedUser = fetchedUserSnapshot.value as? [String: Any] {
                        
                        let userInfo: [String: Any] = [KEY_USER_ID: fetchedUser[KEY_USER_ID] ?? "",
                                                       KEY_USER_NAME: fetchedUser[KEY_USER_NAME] ?? "",
                                                       KEY_CREATED_DATE: fetchedUser[KEY_CREATED_DATE] ?? "",
                                                       ]
                        self.addUsers(userInfo: userInfo)
                    }
                }
            }
        })
    }
    
    func checkingForResgister() {
        
        let aAutoGenkey = Database.database().reference().childByAutoId().key
        let aTimeStlamp = Int(Date().timeIntervalSince1970)

        let userInfo: [String: Any] = [KEY_USER_ID: aAutoGenkey,
                                       KEY_USER_NAME: myTextfield.text ?? "",
                                       KEY_CREATED_DATE: aTimeStlamp,
                                       ]
        
        Database.database().reference().child(USER).queryOrdered(byChild:KEY_USER_NAME).queryEqual(toValue: myTextfield.text).observeSingleEvent(of: .value, with: { snapshot in

            if snapshot.exists(){

                UIAlertController().showAlertViewWithOkAction(self, title: "", message: ALERT_EXISTING_USER, okButtonBlock: { (_ action : UIAlertAction) in

                })
            }
            else{

                Database.database().reference().child(USER).child(userInfo[KEY_USER_ID] as! String).updateChildValues(userInfo)
                self.addUsers(userInfo: userInfo)
            }
        })
    }
    
    func addUsers(userInfo: [String: Any]) {
        // The user details is saved in UserDefaults for remaining screeen 
        UserDefaults().setCurrentUserInfo(aUserInfo: userInfo)
        UserDefaults().isLoggedIn(aBool: true)
        APPDELEGATE?.moveToListScreen()
    }
}
