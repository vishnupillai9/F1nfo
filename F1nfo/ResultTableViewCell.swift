//
//  ResultTableViewCell.swift
//  F1nfo
//
//  Created by Vishnu on 08/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var positionView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var race: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var points: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusView.layer.cornerRadius = 8
        positionView.layer.cornerRadius = 8
    }
}
