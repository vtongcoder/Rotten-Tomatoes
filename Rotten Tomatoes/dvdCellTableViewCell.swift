//
//  dvdCellTableViewCell.swift
//  Rotten Tomatoes
//
//  Created by Dan Tong on 8/30/15.
//  Copyright (c) 2015 DanTong. All rights reserved.
//

import UIKit

class dvdCellTableViewCell: UITableViewCell {

    @IBOutlet weak var dvdTitleLabel: UILabel!
    @IBOutlet weak var dvdSynopsisLabel: UILabel!
    @IBOutlet weak var dvdPosterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
