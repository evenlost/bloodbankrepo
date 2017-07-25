//
//  TableViewCell.swift
//  bloodapp
//
//  Created by HOME on 7/25/17.
//  Copyright © 2017 HOME. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cellbgroup: UILabel!
    @IBOutlet weak var cellcontact: UILabel!
    @IBOutlet weak var cellsn: UILabel!
    @IBOutlet weak var cellname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
