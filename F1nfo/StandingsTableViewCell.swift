//
//  StandingsTableViewCell.swift
//  F1nfo
//
//  Created by Vishnu on 13/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit

class StandingsTableViewCell: UITableViewCell {

    @IBOutlet weak var positionView: UIView!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var points: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        positionView.layer.cornerRadius = 8
        pointsView.layer.cornerRadius = 8
    }
}
