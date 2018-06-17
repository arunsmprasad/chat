//
//  Navigation.swift
//  CropeInChateDemo
//
//  Created by Arunprasat Selvaraj on 6/16/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func setNavigationBarProperties(viewController:UIViewController) {
        
        viewController.navigationController?.navigationBar.barTintColor = UIColor().getColorFromHexa(aValue: COLOR_APP_PRIMARY)
        viewController.navigationController?.navigationBar.tintColor = UIColor.white
        viewController.navigationController?.navigationBar.isTranslucent = true
        viewController.navigationController?.navigationBar.barStyle = .default
        viewController.navigationController?.navigationBar.layer.shadowColor = UIColor.white.cgColor
    }
    
    func setNavigationBarTitle(title: String, viewController: UIViewController) {
        
        // TO SET TILE COLOR & FONT
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = UIColor.white
        viewController.navigationItem.titleView = label
        label.text = title
        label.sizeToFit()
        
        setNavigationBarProperties(viewController:viewController)
    }
}
