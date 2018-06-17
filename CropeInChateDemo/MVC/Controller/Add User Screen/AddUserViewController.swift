//
//  AddUserViewController.swift
//  CropeInChateDemo
//
//  Created by Arunprasat Selvaraj on 6/16/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import UIKit
import Firebase

class AddUserViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myAlertLabel: UILabel!
    
    //Model
    var myUserArray = [User]()
    var myDataBaseRef: DatabaseReference!
    var callBackBlock: ((_ iscallBack: Bool, _ aUserModel: User) -> Void)? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpUI() {
        
        setNavigationBar()
    }
    
    func setUpModel() {
        
        myTableView.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2)
        myTableView.tableFooterView = UIView()
        
        //Get User from Firebase
        getUserInfo()
    }
    
    //MARK: Helper
    
    func setNavigationBar() {
        
        UINavigationController().setNavigationBarTitle(title: SCREEN_TITLE_CHAT, viewController: self)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: self, action: #selector(leftBarButtonTapped))
    }
    
    @objc func leftBarButtonTapped() {
        
        UIAlertController().showAlertViewWithButtonTitle(self, title: "", message: ALERT_LOGOUT, okButtonBlock: { (_ action: UIAlertAction) in
            
            APPDELEGATE?.moveToLoginScreen()

        }) { (_ action: UIAlertAction) in
            
        }
    }
    
    func getUserInfo() {
        // Get all user expect the current user id
        User.getAllUsers(exceptID: HELPER.getCurrentUserId()) { (user) in
            
            DispatchQueue.main.async {
                self.myUserArray.append(user)
                self.myTableView.reloadData()
            }
        }
       
    }
    
    func reloadTableView() {
     
        if self.myUserArray.count > 0 {
            
            self.hideAlert()
            self.myTableView.reloadData()
        }
        else {
            
            self.showAlert()
        }
    }
    
    func showAlert() {
        
        myAlertLabel.text = """
        Sorry! No User's found
        Try again late
        """
        myAlertLabel.isHidden = false
    }
    
    func hideAlert() {
        
        myAlertLabel.isHidden = true
    }
}


extension AddUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var aCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "aCell")
        
        if aCell == nil {
            
            aCell = UITableViewCell.init(style: .default, reuseIdentifier: "aCell")
        }
        let aUserModel = myUserArray[indexPath.row]
        
        aCell?.textLabel?.text = aUserModel.UserName
        
        return aCell!
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        let aUserModel = myUserArray[indexPath.row]

        let aChatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        aChatViewController?.gChatUserId = aUserModel.UserId// To get the chat between the user
        aChatViewController?.gNameString = aUserModel.UserName
        
        self.navigationController?.pushViewController(aChatViewController!, animated: true)
    }
    
    
}
