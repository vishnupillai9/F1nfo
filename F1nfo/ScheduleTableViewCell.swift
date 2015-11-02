//
//  ScheduleTableViewCell.swift
//  F1nfo
//
//  Created by Vishnu on 15/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        calendarView.layer.masksToBounds = true
        calendarView.layer.cornerRadius = 4
    }
    
}
