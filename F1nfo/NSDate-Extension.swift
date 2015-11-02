//
//  NSDate-Extension.swift
//  F1nfo
//
//  Created by Vishnu on 22/06/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import Foundation

extension NSDate
{
    convenience init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }
}