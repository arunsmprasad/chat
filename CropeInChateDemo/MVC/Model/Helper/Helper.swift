//
//  Helper.swift
//  CropeInChateDemo
//
//  Created by Arunprasat Selvaraj on 6/17/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    //MARK - View
    func roundCorner(for view: UIView, radius: Float, borderColor color: UIColor) {
        view.layer.cornerRadius = CGFloat(radius)
        view.layer.borderWidth = 1
        view.layer.borderColor = color.cgColor
        view.clipsToBounds = true
    }
    
    func getCurrentUserId() -> String {
        
       return (UserDefaults().getCurrentUserInfo())[KEY_USER_ID] as! String
    }
    
    func timeIntervalToStringWithInterval(interval: TimeInterval) -> String {
        if (interval == 0) {
            return "Now"
        }
        
        let second:Double = 1
        let minute:Double = second * 60
        let hour:Double = minute * 60
        let day:Double = hour * 24
        let week:Double = day * 7
        // interval can be before (negative) or after (positive)
        var num:Double = abs(interval)
        
        var beforeOrAfter:String = "before"
        var unit:String = "week"
        if (interval > 0) {
            beforeOrAfter = "after"
        }
        
        if (num >= week) {
            num /= week
            if (num > 1) {
                unit = "weeks"
            }
        } else if (num >= day) {
            num /= day
            unit = (num > 1) ? "days" : "day"
        } else if (num >= hour) {
            num /= hour
            unit = (num > 1) ? "hours" : "hour"
        } else if (num >= minute) {
            num /= minute
            unit = (num > 1) ? "minutes" : "minute"
        } else if (num >= second) {
            num /= second
            unit = (num > 1) ? "seconds" : "second"
        }
        
        return String(format: "%.0f %@ %@", num, unit, beforeOrAfter)
    }
}
