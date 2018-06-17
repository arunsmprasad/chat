//
//  Alert.swift
//  CropeInChateDemo
//
//  Created by Arunprasat Selvaraj on 6/15/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    
    func showAlertViewWithOkAction(_ aViewController: UIViewController, title aTitle: String, message aMessage: String, okButtonBlock okAction: @escaping (_ action: UIAlertAction) -> Void) {
        
        let alert = UIAlertController(title: aTitle, message: aMessage, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            okAction(action)
        })
        
        alert.addAction(Ok)
        aViewController.present(alert, animated: true, completion: nil)
    }
    
    func showAlertViewWithButtonTitle(_ aViewController: UIViewController, title aTitle: String, message aMessage: String, okButtonBlock okAction: @escaping (_ action: UIAlertAction) -> Void, cancelButtonBlock cancelAction: @escaping (_ action: UIAlertAction) -> Void) {
        
        let alert = UIAlertController(title: aTitle, message: aMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let Ok = UIAlertAction(title: OK_BUTTON_TITLE, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            okAction(action)
        })
        
        let cancel = UIAlertAction(title: CANCEL_BUTTON_TITLE, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            
            cancelAction(action)
        })
        
        alert.addAction(Ok)
        alert.addAction(cancel)
        
        aViewController.present(alert, animated: true, completion: nil)
    }
    
}
